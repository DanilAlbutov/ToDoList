import UIKit
import SnapKit

final class DetailsViewController: UIViewController, UITextViewDelegate {
    var output: DetailsViewOutput?
    
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var titleHeightConstraint: Constraint?
    private var descriptionHeightConstraint: Constraint?
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 48, weight: .bold)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        return textView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = ToDoListAsset.Assets.secondaryText.color
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.font = .systemFont(ofSize: 22, weight: .regular)
        textView.isScrollEnabled = false
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
        return textView
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
        output?.viewDidLoad()
    }
    
    private func setupLayout() {
        view.backgroundColor = .black
        navigationItem.rightBarButtonItem = saveBarButton
        navigationItem.backButtonTitle = "Назад"
        
        titleTextView.delegate = self
        descriptionTextView.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionTextView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleTextView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            titleHeightConstraint = $0.height.equalTo(56).constraint
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(8)
            $0.left.equalTo(titleTextView.snp.left)
            $0.right.lessThanOrEqualTo(contentView).inset(16)
        }
        
        descriptionTextView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(contentView).inset(16)
            $0.bottom.equalTo(contentView.snp.bottom).inset(16)
            descriptionHeightConstraint = $0.height.equalTo(120).constraint
        }
        
        updateTextViewHeights()
    }
    
    @objc
    private func handleSaveTap() {
        output?.didTapSave(
            title: titleTextView.text ?? "",
            description: descriptionTextView.text ?? ""
        )
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateTextViewHeights()
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
        updateTextViewHeights()
    }
    
    func updateSaveButton(isEnabled: Bool) {
        saveBarButton.isEnabled = isEnabled
    }
}

private extension DetailsViewController {
    func updateTextViewHeights() {
        let width = view.bounds.width - 32
        guard width > 0 else {
            return
        }

        let titleTargetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let titleHeight = max(56, titleTextView.sizeThatFits(titleTargetSize).height)
        titleHeightConstraint?.update(offset: titleHeight)

        let detailsTargetSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let detailsHeight = max(120, descriptionTextView.sizeThatFits(detailsTargetSize).height)
        descriptionHeightConstraint?.update(offset: detailsHeight)
    }
}
