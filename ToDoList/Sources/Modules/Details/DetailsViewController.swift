import UIKit
import SnapKit

final class DetailsViewController: UIViewController, UITextViewDelegate {
    var output: DetailsViewOutput?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titlePlaceholder = "Название"
    private let descriptionPlaceholder = "Описание"
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = ToDoListAsset.Assets.primaryText.color
        textView.font = .systemFont(ofSize: 34, weight: .bold)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        return textView
    }()

    private let titlePlaceholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = ToDoListAsset.Assets.secondaryText.color
        label.font = .systemFont(ofSize: 34, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = ToDoListAsset.Assets.secondaryText.color
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = ToDoListAsset.Assets.primaryText.color
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        return textView
    }()

    private let descriptionPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.textColor = ToDoListAsset.Assets.secondaryText.color
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private lazy var saveBarButton = UIBarButtonItem(
        title: "Сохранить",
        style: .done,
        target: self,
        action: #selector(handleSaveTap)
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupKeyboardHandling()
        output?.viewDidLoad()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func updatePlaceholders() {
        titlePlaceholderLabel.isHidden = !(titleTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        descriptionPlaceholderLabel.isHidden = !(descriptionTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc
    private func handleKeyboardWillShow(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardFrame = view.convert(frameValue.cgRectValue, from: nil)
        let overlap = max(0, view.bounds.maxY - keyboardFrame.minY)
        scrollView.contentInset.bottom = overlap + 12
        scrollView.verticalScrollIndicatorInsets.bottom = overlap + 12
    }

    @objc
    private func handleKeyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        navigationItem.title = nil
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.backButtonTitle = "Назад"
        navigationController?.navigationBar.tintColor = ToDoListAsset.Assets.yellow.color
        saveBarButton.tintColor = ToDoListAsset.Assets.yellow.color
        saveBarButton.setTitleTextAttributes(
            [.foregroundColor: ToDoListAsset.Assets.yellow.color],
            for: .normal
        )
        saveBarButton.setTitleTextAttributes(
            [.foregroundColor: ToDoListAsset.Assets.secondaryText.color],
            for: .disabled
        )
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        contentView.addSubview(titleTextView)
        titleTextView.delegate = self
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.horizontalEdges.equalTo(contentView).inset(16)
        }
        
        titleTextView.addSubview(titlePlaceholderLabel)
        titlePlaceholderLabel.text = titlePlaceholder
        titlePlaceholderLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.textContainerInset.top)
            $0.left.equalTo(titleTextView.textContainerInset.left + titleTextView.textContainer.lineFragmentPadding)
            $0.right.lessThanOrEqualToSuperview()
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(8)
            $0.left.equalTo(titleTextView.snp.left)
            $0.right.lessThanOrEqualTo(contentView).inset(16)
        }
        
        contentView.addSubview(descriptionTextView)
        descriptionTextView.delegate = self
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(16)
            $0.height.greaterThanOrEqualTo(400)
        }
        
        descriptionTextView.addSubview(descriptionPlaceholderLabel)
        descriptionPlaceholderLabel.text = descriptionPlaceholder
        descriptionPlaceholderLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionTextView.textContainerInset.top)
            $0.left.equalTo(descriptionTextView.textContainerInset.left + descriptionTextView.textContainer.lineFragmentPadding)
            $0.right.lessThanOrEqualToSuperview()
        }
        
        updatePlaceholders()        
    }
    
    @objc
    private func handleSaveTap() {
        output?.didTapSave(
            title: titleTextView.text ?? "",
            description: descriptionTextView.text ?? ""
        )
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updatePlaceholders()
        if textView === titleTextView {
            output?.titleDidChange(textView.text)
        }
    }
}

extension DetailsViewController: DetailsViewInput {
    func setupInitialState(with viewModel: DetailsViewModel) {
        titleTextView.text = viewModel.title
        descriptionTextView.text = viewModel.description
        dateLabel.text = viewModel.dateText
        saveBarButton.title = viewModel.saveButtonTitle
        updatePlaceholders()
    }
    
    func updateSaveButton(isEnabled: Bool) {
        saveBarButton.isEnabled = isEnabled
    }
}
