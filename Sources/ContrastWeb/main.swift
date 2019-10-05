import Color
import Kitura
import KituraCompression
import KituraStencil

let router = Router()

router.all(middleware: Compression())
router.add(templateEngine: StencilTemplateEngine())
router.all("/assets", middleware: StaticFileServer(path: "./assets", options: StaticFileServer.Options(serveIndexForDirectory: false)))

router.get("/:foreground/:background") { request, response, next in
    guard let foregroundHex = request.parameters["foreground"], foregroundHex != "assets",
        let backgroundHex = request.parameters["background"] else
    {
        next()
        return
    }

    guard let foreground = RGBColor(hex: foregroundHex), let background = RGBColor(hex: backgroundHex) else {
        try response.render("error.stencil", context: ["title": "Error"])
        response.status(.badRequest)
        return
    }

    let ratio = foreground.contrastRatio(to: background)
    let formattedRatio = String(format: "%0.2f", ratio)
    let score = ConformanceLevel(contrastRatio: ratio)

    let context: [String: String] = [
        "title": "\(score.description) \(formattedRatio)",
        "ratio": formattedRatio,
        "score": score.description,
        "foreground": foreground.hex,
        "background": background.hex,
        "extendedDescription": score.extendedDescription
    ]

    do {
        try response.render("score.stencil", context: context)
    } catch {
        response.error = error
        next()
    }

    response.status(.OK)
}

router.get() { request, response, next in
    let path = request.parsedURL.path ?? "/"

    if path.hasPrefix("/assets/") {
        next()
        return
    }

    try response.redirect("https://usecontrast.com\(path)").end()
}

Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.run()
