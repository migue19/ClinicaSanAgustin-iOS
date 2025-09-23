import UIKit

class CardView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .large
        configuration.baseBackgroundColor = .primaryC
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        return button
    }()
    private lazy var spacer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: customSpacing)
        ])
        return view
    }()
    private var customSpacing: CGFloat = 4
    private lazy var stack: UIStackView = {
        let stack = UIStackView.v(8)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(subtitleLabel)
        stack.addArrangedSubview(spacer)
        stack.addArrangedSubview(actionButton)
        return stack
    }()

    init(title: String, subtitle: String?, buttonTitle: String = "Abrir", target: Any?, action: Selector, spacing: CGFloat = 24) {
        self.customSpacing = spacing
        super.init(frame: .zero)
        setupView()
        configure(title: title, subtitle: subtitle, buttonTitle: buttonTitle, target: target, action: action)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16
        layer.masksToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func configure(title: String, subtitle: String?, buttonTitle: String, target: Any?, action: Selector) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        actionButton.setTitle(buttonTitle, for: .normal)
        actionButton.removeTarget(nil, action: nil, for: .allEvents)
        if let target {
            actionButton.addTarget(target, action: action, for: .touchUpInside)
        }
        subtitleLabel.isHidden = subtitle == nil
    }
}
