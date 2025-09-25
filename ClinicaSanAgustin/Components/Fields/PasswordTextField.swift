import UIKit

final class PasswordTextField: UITextField {
    private let eyeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.baseForegroundColor = .gray
        let b = UIButton(configuration: config)
        b.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        b.tintColor = .gray
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        isSecureTextEntry = true
        borderStyle = .roundedRect
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 36))
        eyeButton.frame = CGRect(x: 0, y: 0, width: 26, height: 36)
        eyeButton.contentHorizontalAlignment = .right
        container.addSubview(eyeButton)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eyeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: 0),
            eyeButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            eyeButton.widthAnchor.constraint(equalToConstant: 24),
            eyeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        rightView = container
        rightViewMode = .always
        eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
    }

    @objc private func toggleVisibility() {
        isSecureTextEntry.toggle()
        let imageName = isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
