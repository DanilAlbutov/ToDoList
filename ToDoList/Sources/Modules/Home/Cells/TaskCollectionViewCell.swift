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
    let infoConfig: TaskInfoView.Configuration
}

final class TaskCollectionViewCell: UICollectionViewListCell {
    var onCheckButtonTapped: (() -> Void)?
    
    typealias Configuration = TaskCollectionViewCellConfiguration
    
    private var configuration: Configuration?
    
    // MARK: - UI
    
    private let checkButton = CheckMarkButton(type: .custom)
    private let taskInfoView = TaskInfoView()
    
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
        updateCompletedState(model.infoConfig)
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        contentView.backgroundColor = .black
        contentView.addSubview(checkButton)
        checkButton.addTarget(self, action: #selector(handleCheckButtonTap), for: .touchUpInside)
        contentView.addSubview(taskInfoView)
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
        
        taskInfoView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(checkButton.snp.right).offset(8)
            $0.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    private func updateCompletedState(_ config: TaskInfoView.Configuration) {
        guard let configuration else { return }
        checkButton.setCompleted(config.isCompleted)
        taskInfoView.configure(with: config)
    }
}
