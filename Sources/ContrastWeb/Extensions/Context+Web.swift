import Cairo

enum TextAlignment {
    case left
    case center
    case right
}

extension Context {
    func draw(text: String, at point: (x: Double, y: Double), horizontalAlignment: TextAlignment) {
        let extents = self.extents(for: text)
        var point = point

        switch horizontalAlignment {
        case .left:
            break
        case .center:
            point.x -= extents.width / 2
        case .right:
            point.x -= extents.width
        }

        move(to: (x: point.x, y: point.y))
        show(text: text)
    }
}
