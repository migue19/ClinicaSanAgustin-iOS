
import UIKit

final class PillButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }
    private func setup() {
        layer.cornerRadius = 16
        layer.masksToBounds = true
        //contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        setTitleColor(.white, for: .selected)
        setTitleColor(.label, for: .normal)
        backgroundColor = .systemGray6
        titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
    }
    override var isSelected: Bool { didSet { backgroundColor = isSelected ? .systemBlue : .systemGray6 } }
}

extension UIStackView {
    static func v(_ spacing: CGFloat = 8) -> UIStackView {
        let s = UIStackView(); s.axis = .vertical; s.spacing = spacing; return s
    }
    static func h(_ spacing: CGFloat = 8) -> UIStackView {
        let s = UIStackView(); s.axis = .horizontal; s.spacing = spacing; return s
    }
}
