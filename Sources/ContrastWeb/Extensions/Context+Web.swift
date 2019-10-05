import Cairo
import CCairo

enum TextAlignment {
    case left
    case center
    case right
}

enum VerticalAlignment {
    case top
    case center
}

typealias FontExtents = cairo_font_extents_t

extension Context {
    func draw(text: String, at point: (x: Double, y: Double), horizontalAlignment: TextAlignment,
              verticalAlignment: VerticalAlignment = .top)
    {
        var point = point

        switch horizontalAlignment {
        case .left:
            break
        case .center:
            point.x -= extents(for: text).width / 2
        case .right:
            point.x -= extents(for: text).width
        }

        switch verticalAlignment {
        case .top:
            break
        case .center:
            let fontExtents = self.fontExtents()
            point.y += 0.5 - fontExtents.descent + fontExtents.height / 2
        }

        move(to: (x: point.x, y: point.y))
        show(text: text)
    }

    func fontExtents() -> FontExtents {
        var extents = FontExtents()
        cairo_font_extents(pointer, &extents)
        return extents
    }
}
