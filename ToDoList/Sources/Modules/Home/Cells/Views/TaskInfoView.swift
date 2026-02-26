//
//  TaskInfoView.swift
//  ToDoList
//
//  Created by Данил Албутов on 26.02.2026.
//

import UIKit
import SnapKit



final class TaskInfoView: UIView {
    struct Configuration: Hashable {
        let title: String
        let description: String
        let date: String
        let isCompleted: Bool
    }

    private let titleLabel = TDLLabel(
        style: .bodySemiboldPrimary,
        textColor: .primaryText
    )
    private let descriptionLabel = TDLLabel(
        style: .captionSecondary,
        textColor: .secondaryText
    )
    private let dateLabel = TDLLabel(
        style: .captionSecondary,
        textColor: .secondaryText
    )
    private let textStack = UIStackView()
    
    override var intrinsicContentSize: CGSize {
        textStack.bounds.size
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with model: Configuration) {
        titleLabel.setAttributedText(
            model.title,
            withStrikethrough: model.isCompleted
        )
        descriptionLabel.text = model.description
        dateLabel.text = model.date
        updateColors(isCompleted: model.isCompleted)
    }

    private func setupViews() {
        addSubview(textStack)
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textStack.addArrangedSubview(titleLabel)        
        textStack.addArrangedSubview(descriptionLabel)        
        textStack.addArrangedSubview(dateLabel)
    }
    
    private func updateColors(isCompleted: Bool) {
        descriptionLabel.apply(
            textColor: isCompleted
            ? .secondaryText
            : .primaryText
        )
        dateLabel.apply(textColor: .secondaryText)
    }
}

private extension UILabel {
    func setAttributedText(
        _ text: String,
        withStrikethrough: Bool = false
    ) {
        let baseFont: UIFont = TDLLabelStyle.bodySemiboldPrimary.font

        let color: UIColor = withStrikethrough ? .secondaryText : .primaryText

        var attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: baseFont
        ]

        if withStrikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        attributedText = NSAttributedString(string: text, attributes: attributes)
    }
}
