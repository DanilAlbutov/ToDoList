//
//  HomeTaskPreviewPopoverView.swift
//  ToDoList
//
//  Created by Данил Албутов on 26.02.2026.
//

import Foundation
import UIKit

final class HomeTaskPreviewPopoverView: UIViewController {
    typealias Configuration = TaskInfoView.Configuration
    private let configuration: Configuration
    private let contentInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)

    private let taskInfoView = TaskInfoView()

    init(configuration: Configuration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        applyConfiguration()
        setupLayout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updatePreferredContentSize()
    }

    private func setupUI() {
        view.backgroundColor = .appGray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true

        view.addSubview(taskInfoView)
        taskInfoView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(contentInsets)
        }
    }

    private func setupLayout() {
        updatePreferredContentSize()
    }

    private func applyConfiguration() {
        taskInfoView.configure(with: configuration)
    }

    private func updatePreferredContentSize() {
        let maxWidth = UIScreen.main.bounds.width
        let minHeight: CGFloat = 100 
        let contentWidth = maxWidth - contentInsets.left - contentInsets.right
        let contentSize = taskInfoView.systemLayoutSizeFitting(
            CGSize(width: contentWidth, height: minHeight),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        let width = contentSize.width + contentInsets.left + contentInsets.right
        let height = contentSize.height + contentInsets.top + contentInsets.bottom
        preferredContentSize = CGSize(width: width, height: height)
    }
}
