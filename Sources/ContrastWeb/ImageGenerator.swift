import Cairo
import Color
import Foundation

final class ImageGenerator {

    // MARK: - Types

    enum Error: Swift.Error {
        case failedToRender
    }

    // MARK: - Properties

    private static let width: Double = 1280
    private static let height: Double = 640
    private static let padding: Double = 64
    private static let familyName = "Rubik"

    // MARK: - Generating

    static func generate(foreground: Color.RGBColor, background: Color.RGBColor) throws -> Data {
        let ratio = foreground.contrastRatio(to: background)
        let score = ConformanceLevel(contrastRatio: ratio)

        let surface = try Surface.Image(format: .argb32, width: Int(width), height: Int(height))
        let context = Context(surface: surface)

        // Background
        context.setSource(color: background.tuple)
        context.addRectangle(x: 0, y: 0, width: width, height: height)
        context.fill()

        context.setSource(color: foreground.tuple)
        context.setFont(face: (family: familyName, slant: .normal, weight: .bold))

        // Score
        context.setFont(size: 128)
        context.draw(text: score.description, at: (x: width / 2, y: height / 2), horizontalAlignment: .center)

        // Ratio
        context.setFont(size: 32)
        context.draw(text: String(format: "%0.2f", ratio), at: (x: width / 2, y: height - padding),
                     horizontalAlignment: .center)

        // Domain
        context.setFont(face: (family: familyName, slant: .normal, weight: .normal))
        context.draw(text: "usecontra.st", at: (x: width - padding, y: padding), horizontalAlignment: .right)

        // Foreground
        context.draw(text: "#\(foreground.hex)", at: (x: padding, y: height - padding), horizontalAlignment: .left)

        // Background
        context.draw(text: "#\(background.hex)", at: (x: width - padding, y: height - padding),
                     horizontalAlignment: .right)

        // Render
        return try surface.writePNG()
    }
}
