import UIKit

final class PrimaryButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    convenience init(title: String) {
        self.init(type: .system)
        setTitle(title, for: .normal)
    }
    private func setup() {
        var config = UIButton.Configuration.bordered()
        config.title = self.title(for: .normal)
        config.cornerStyle = .capsule
        config.buttonSize = .large
        config.baseBackgroundColor = .primaryC
        config.baseForegroundColor = .white
        self.configuration = config
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
