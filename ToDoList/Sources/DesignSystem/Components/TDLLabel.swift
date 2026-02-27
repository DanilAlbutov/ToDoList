import UIKit

enum TDLLabelStyle {
    case h1Secondary
    case bodyPrimary
    case bodySecondary
    case bodySemiboldPrimary
    case captionPrimary
    case captionSecondary
    case captionMediumInverse

    var font: UIFont {
        switch self {
        case .h1Secondary:
            return .systemFont(ofSize: 34, weight: .bold)
        case .bodyPrimary, .bodySecondary:
            return .systemFont(ofSize: 16, weight: .regular)
        case .bodySemiboldPrimary:
            return .systemFont(ofSize: 16, weight: .semibold)
        case .captionPrimary, .captionSecondary:
            return .systemFont(ofSize: 12, weight: .regular)
        case .captionMediumInverse:
            return .systemFont(ofSize: 11, weight: .medium)
        }
    }

    var numberOfLines: Int {
        switch self {
        case .bodySemiboldPrimary:
            return 1
        case .captionPrimary, .captionSecondary:
            return 2
        case .h1Secondary, .bodyPrimary, .bodySecondary, .captionMediumInverse:
            return 0
        }
    }

    var textAlignment: NSTextAlignment {
        switch self {
        case .captionMediumInverse:
            return .center
        default:
            return .natural
        }
    }
}

final class TDLLabel: UILabel {
    private(set) var style: TDLLabelStyle

    init(style: TDLLabelStyle, textColor: UIColor) {
        self.style = style
        super.init(frame: .zero)
        apply(style: style)
        self.textColor = textColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(style: TDLLabelStyle) {
        self.style = style
        font = style.font
        numberOfLines = style.numberOfLines
        textAlignment = style.textAlignment
    }

    func apply(textColor: UIColor) {
        self.textColor = textColor
    }
}
