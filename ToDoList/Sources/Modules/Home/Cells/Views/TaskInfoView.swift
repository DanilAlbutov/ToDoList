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

    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()
    private let textStack = UIStackView()
    
    override var intrinsicContentSize: CGSize {
        textStack.bounds.size
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
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

    private func setupUI() {
        addSubview(textStack)
        textStack.axis = .vertical
        textStack.spacing = 6
        textStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textStack.addArrangedSubview(titleLabel)
        titleLabel.numberOfLines = 1
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        
        textStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        
        textStack.addArrangedSubview(dateLabel)
        dateLabel.font = .systemFont(ofSize: 12, weight: .regular)        
    }
    
    private func updateColors(isCompleted: Bool) {
        descriptionLabel.textColor = isCompleted
        ? ToDoListAsset.Assets.secondaryText.color
        : ToDoListAsset.Assets.primaryText.color
        dateLabel.textColor = ToDoListAsset.Assets.secondaryText.color
    }
}

private extension UILabel {
    func setAttributedText(
        _ text: String,
        withStrikethrough: Bool = false
    ) {
        let baseFont: UIFont = .systemFont(ofSize: 16, weight: .bold)

        let color: UIColor = withStrikethrough
        ? ToDoListAsset.Assets.secondaryText.color
        : ToDoListAsset.Assets.primaryText.color

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
