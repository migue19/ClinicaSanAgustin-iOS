import UIKit



extension UIStackView {
    static func v(_ spacing: CGFloat = 8) -> UIStackView {
        let s = UIStackView(); s.axis = .vertical; s.spacing = spacing; return s
    }
    static func h(_ spacing: CGFloat = 8) -> UIStackView {
        let s = UIStackView(); s.axis = .horizontal; s.spacing = spacing; return s
    }
}
