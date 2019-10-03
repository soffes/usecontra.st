import Color
import Kitura
import KituraStencil

let router = Router()

router.add(templateEngine: StencilTemplateEngine())

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
    let formattedRatio = String(format: "%0.2f", ratio)
    let score = ConformanceLevel(contrastRatio: ratio)

    let context: [String: String] = [
        "title": "Contrast — \(score.description) \(formattedRatio)",
        "ratio": formattedRatio,
        "score": score.description,
        "foreground": foreground.hex,
        "background": background.hex
    ]

    do {
        try response.render("Score.stencil", context: context)
    } catch {
        response.error = error
        next()
    }

    response.status(.OK)
}

router.get() { request, response, next in
    let path = request.parsedURL.path ?? "/"
    try response.redirect("https://usecontrast.com\(path)").end()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
