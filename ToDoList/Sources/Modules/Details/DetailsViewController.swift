import UIKit
import SnapKit

final class DetailsViewController: UIViewController, UITextViewDelegate {
    var output: DetailsViewOutput?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let titleTextView = TDLPlaceholderTextView(
        placeholder: "Название",
        style: .h1Secondary
    )
    
    private let dateLabel = TDLLabel(
        style: .bodySecondary,
        textColor: .secondaryText
    )
    
    private let descriptionTextView = TDLPlaceholderTextView(
        placeholder: "Описание",
        style: .bodyPrimary
    )
    
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
        navigationController?.navigationBar.tintColor = .appYellow
        saveBarButton.tintColor = .appYellow
        saveBarButton.setTitleTextAttributes(
            [.foregroundColor: UIColor.appYellow],
            for: .normal
        )
        saveBarButton.setTitleTextAttributes(
            [.foregroundColor: UIColor.secondaryText],
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
    }
    
    @objc
    private func handleSaveTap() {
        output?.didTapSave(
            title: titleTextView.text ?? "",
            description: descriptionTextView.text ?? ""
        )
    }
    
    func textViewDidChange(_ textView: UITextView) {
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
    }
    
    func updateSaveButton(isEnabled: Bool) {
        saveBarButton.isEnabled = isEnabled
    }
}
