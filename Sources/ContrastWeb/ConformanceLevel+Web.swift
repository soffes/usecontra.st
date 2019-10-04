import Color

extension ConformanceLevel {
    var extendedDescription: String {
        switch self {
        case .aaa:
            return """
            This text passes the highest tier of contrast accessibility. Scores between 7.5–21 receive <strong>AAA</strong>. This score is valid for all font sizes.
            """
        case .aa:
            return """
            This text passes the middle tier of contrast accessibility. Scores between 4.5–7.49 receive <strong>AA</strong>. This score is valid for all font sizes.
            """
        case .aaLarge:
            return """
            This text passes the lowest tier of contrast accessibility. Scores between 3.0–4.49 receive <strong>AA+</strong> (AA Large). This score is only valid for 14pt bold and 18pt regular font sizes.
            """
        case .fail:
            return """
            This text fails to pass any tier of contrast accessibility. Scores between 1–2.99 receive <strong>Fail</strong>. This score is valid for all font sizes.
            """
        }
    }
}
