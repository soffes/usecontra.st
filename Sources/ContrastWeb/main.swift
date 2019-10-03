import Color
import Kitura

let router = Router()

router.get("/:foreground/:background") { request, response, next in
    guard let foregroundHex = request.parameters["foreground"],
        let backgroundHex = request.parameters["background"] else
    {
        next()
        return
    }

    guard let foreground = RGBColor(hex: foregroundHex), let background = RGBColor(hex: backgroundHex) else {
        try response.send("invalid colors").end()
        return
    }

    let ratio = foreground.contrastRatio(to: background)
    let score = ConformanceLevel(contrastRatio: ratio)

    try response.send("\(score) \(ratio)").end()
}

router.get() { request, response, next in
    let path = request.parsedURL.path ?? "/"
    try response.redirect("https://usecontrast.com\(path)").end()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
