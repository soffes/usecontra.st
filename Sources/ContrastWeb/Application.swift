import Color
import Foundation
import Kitura
import KituraCompression
import KituraStencil

final class Application {

    // MARK: - Properties

    private let router = Router()
    let port: Int

    // MARK: - Initializers

    init(port: Int? = nil) {
        self.port = port ?? ProcessInfo.processInfo.environment["PORT"].flatMap(Int.init) ?? 8080

        router.all(middleware: Compression())
        router.add(templateEngine: StencilTemplateEngine())

        let options = StaticFileServer.Options(serveIndexForDirectory: false)
        router.all("/assets", middleware: StaticFileServer(path: "./assets", options: options))

        // Configure routes
        router.get("/og/:foreground/:background.png", handler: openGraphImage)
        router.get("/:foreground/:background", handler: score)
        router.get(handler: catchAll)

        Kitura.addHTTPServer(onPort: self.port, with: router)
    }

    // MARK: - Running the server

    func run() {
        Kitura.run()
    }

    // MARK: - Routes

    private func score(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let foregroundHex = request.parameters["foreground"], foregroundHex != "assets",
            let backgroundHex = request.parameters["background"], !backgroundHex.hasSuffix(".png") else
        {
            next()
            return
        }

        guard let foreground = RGBColor(hex: foregroundHex), let background = RGBColor(hex: backgroundHex) else {
            try response.render("error.stencil", context: ["title": "Oops, no contrast"])
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
            "extendedDescription": score.extendedDescription,
            "metaDescription": "WCAG color contrast rating for #\(foreground.hex) and #\(background.hex).",
            "ogImageURL": "https://usecontra.st/og/\(foreground.hex)/\(background.hex).png"
        ]

        do {
            try response.render("score.stencil", context: context)
        } catch {
            response.error = error
            next()
        }

        response.status(.OK)
    }

    private func openGraphImage(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        guard let foregroundHex = request.parameters["foreground"],
            let backgroundHex = request.parameters["background"]?.replacingOccurrences(of: ".png", with: "") else
        {
            next()
            return
        }

        guard let foreground = RGBColor(hex: foregroundHex), let background = RGBColor(hex: backgroundHex) else {
            response.status(.badRequest)
            try response.end()
            return
        }

        response.headers["Content-Type"] = "image/png"

        let imageData = try ImageGenerator.generate(foreground: foreground, background: background)
        response.send(data: imageData)
    }

    private func catchAll(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) throws {
        let path = request.parsedURL.path ?? "/"

        if path.hasPrefix("/assets/") {
            next()
            return
        }

        try response.redirect("https://usecontrast.com\(path)").end()
    }
}
