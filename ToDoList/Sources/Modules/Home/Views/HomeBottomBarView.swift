import UIKit
import SnapKit

final class HomeBottomBarView: UIView {
    var onComposeTapped: (() -> Void)?

    private let tasksCountLabel = TDLLabel(
        style: .captionMediumInverse,
        textColor: .white
    )

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.pencil")
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        return button
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTasksCount(_ count: Int) {
        tasksCountLabel.text = "\(count) Задач"
    }

    private func setupUI() {
        backgroundColor = UIColor(white: 0.14, alpha: 1)
        addSubview(tasksCountLabel)
        addSubview(editButton)
        editButton.addTarget(self, action: #selector(handleComposeTap), for: .touchUpInside)
    }

    private func setupLayout() {
        tasksCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(26)
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(tasksCountLabel)
            $0.right.equalToSuperview().inset(28)
            $0.size.equalTo(34)
        }
    }

    @objc
    private func handleComposeTap() {
        onComposeTapped?()
    }
}
