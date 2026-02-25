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
    
    override var isSelected: Bool {
        didSet {
            updateCompletedState(isSelected)
        }
    }
    
    private var configuration: Configuration?
    
    // MARK: - UI
    
    private let checkButton = CheckMarkButton(type: .custom)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemGray2
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .systemGray3
        return label
    }()    
    
    private let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray5
        return view
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
    
    func configure(with model: TaskCollectionViewCellConfiguration) {
        configuration = model
        titleLabel.setAttributedText(model.title)
        descriptionLabel.text = model.description
        dateLabel.text = model.date
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        checkButton.addTarget(self, action: #selector(handleCheckButtonTap), for: .touchUpInside)

        contentView.addSubview(checkButton)
        
        textStack.axis = .vertical
        textStack.spacing = 4
        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(descriptionLabel)
        textStack.addArrangedSubview(dateLabel)
        
        contentView.addSubview(textStack)
        contentView.addSubview(separatorView)
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
        descriptionLabel.textColor = completed ? .systemGray : .systemGray2
        titleLabel.setAttributedText(configuration?.title ?? "", withStrikethrough: completed)
    }
}

fileprivate extension UILabel {
    func setAttributedText(_ text: String, withStrikethrough: Bool = false) {
        var attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: UIColor.systemGray
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
