//
//  TaskCollectionViewCell.swift
//  ToDoList
//
//  Created by Данил Албутов on 20.02.2026.
//

import UIKit
import SnapKit

struct TaskCollectionViewCellConfiguration: Hashable {
    let id: String
    let title: String
    let description: String
    let date: String
    var isCompleted: Bool
}

final class TaskCollectionViewCell: UICollectionViewListCell {
    var onCheckButtonTapped: (() -> Void)?
    
    typealias Configuration = TaskCollectionViewCellConfiguration
    
    private var configuration: Configuration?
    
    // MARK: - UI
    
    private let checkButton = CheckMarkButton(type: .custom)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = ToDoListAsset.Assets.secondaryText.color
        label.numberOfLines = 2
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = ToDoListAsset.Assets.secondaryText.color
        return label
    }()
    
    private let textStack = UIStackView()
    
    // MARK: - State
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onCheckButtonTapped = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Configuration
    
    func configure(with model: Configuration) {
        configuration = model
        titleLabel.setAttributedText(model.title)
        descriptionLabel.text = model.description
        dateLabel.text = model.date
        updateCompletedState(model.isCompleted)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(checkButton)
        checkButton.addTarget(self, action: #selector(handleCheckButtonTap), for: .touchUpInside)
        
        textStack.axis = .vertical
        textStack.spacing = 6        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.addArrangedSubview(dateLabel)
        
        contentView.addSubview(textStack)
    }

    @objc
    private func handleCheckButtonTap() {
        onCheckButtonTapped?()
    }
    
    private func setupLayout() {        
        checkButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(28)
        }
        
        textStack.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(checkButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func updateCompletedState(_ completed: Bool) {        
        checkButton.setCompleted(completed)
        descriptionLabel.textColor = .color(forState: !completed)
        titleLabel.setAttributedText(configuration?.title ?? "", withStrikethrough: completed)
    }
}

fileprivate extension UIColor {    
    static func color(forState isActive: Bool) -> UIColor {
        return isActive 
        ? ToDoListAsset.Assets.primaryText.color 
        : ToDoListAsset.Assets.secondaryText.color
    }
}

fileprivate extension UILabel {
    func setAttributedText(_ text: String, withStrikethrough: Bool = false) {
        let color: UIColor = withStrikethrough 
        ? ToDoListAsset.Assets.secondaryText.color 
        : ToDoListAsset.Assets.primaryText.color
        var attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: color,
            .font: UIFont.systemFont(ofSize: 16, weight: .semibold)
        ]
        if withStrikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }
        let attributedString = NSAttributedString(
            string: text,
            attributes: attributes
        )
        attributedText = attributedString
    }
}
