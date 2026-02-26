import UIKit
import SnapKit

final class TDLPlaceholderTextView: UITextView {
    private let placeholderLabel = UILabel()
    private let style: TDLLabelStyle

    var placeholder: String {
        get { placeholderLabel.text ?? "" }
        set { placeholderLabel.text = newValue }
    }

    var placeholderColor: UIColor {
        get { placeholderLabel.textColor ?? .secondaryText }
        set { placeholderLabel.textColor = newValue }
    }

    override var text: String! {
        didSet { updatePlaceholderVisibility() }
    }

    override var attributedText: NSAttributedString! {
        didSet { updatePlaceholderVisibility() }
    }

    init(
        placeholder: String,
        style: TDLLabelStyle,
        textColor: UIColor = .primaryText,
        placeholderColor: UIColor = .secondaryText
    ) {
        self.style = style
        super.init(frame: .zero, textContainer: nil)
        self.placeholder = placeholder
        self.font = style.font
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        setupUI()
        setupObserver()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func setupUI() {
        backgroundColor = .clear
        isScrollEnabled = false
        textContainerInset = .zero
        textContainer.lineFragmentPadding = .zero

        placeholderLabel.font = style.font
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(textContainerInset.top)
            $0.left.equalToSuperview().offset(
                textContainerInset.left + textContainer.lineFragmentPadding
            )
            $0.right.lessThanOrEqualToSuperview()
        }
        updatePlaceholderVisibility()
    }

    private func setupObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textDidChangeNotification),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc
    private func textDidChangeNotification() {
        updatePlaceholderVisibility()
    }

    private func updatePlaceholderVisibility() {
        let value = text ?? ""
        placeholderLabel.isHidden = !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
