import UIKit
import SnapKit

final class CheckMarkButton: UIButton {
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .black
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setCompleted(_ isCompleted: Bool) {
        layer.borderColor = isCompleted ? UIColor.systemYellow.cgColor : UIColor.systemGray3.cgColor
        backgroundColor = isCompleted ? .systemYellow : .black
        checkImageView.isHidden = !isCompleted
    }

    private func setupAppearance() {
        layer.cornerRadius = 14
        layer.borderWidth = 2
        layer.borderColor = UIColor.border.cgColor
    }

    private func setupLayout() {
        addSubview(checkImageView)

        checkImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(14)
        }
    }
}
