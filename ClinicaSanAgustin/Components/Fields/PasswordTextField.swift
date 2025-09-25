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
        let sizeEyeButton: CGFloat = 24
        let padding: CGFloat = 16
        isSecureTextEntry = true
        borderStyle = .roundedRect
        // Only wrap the button with minimal container width
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(eyeButton)
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eyeButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding), // 8pt right padding
            eyeButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            eyeButton.widthAnchor.constraint(equalToConstant: sizeEyeButton),
            eyeButton.heightAnchor.constraint(equalToConstant: sizeEyeButton),
            container.widthAnchor.constraint(equalToConstant: sizeEyeButton + padding),
            container.heightAnchor.constraint(equalToConstant: sizeEyeButton)
        ])
        rightView = container
        rightViewMode = .always
        eyeButton.addTarget(self, action: #selector(toggleVisibility), for: .touchUpInside)
    }

    @objc private func toggleVisibility() {
        // Save cursor position
        let wasFirstResponder = isFirstResponder
        let currentText = text
        let selectedRange = selectedTextRange
        isSecureTextEntry.toggle()
        // Workaround for iOS bug: re-assign text to refresh field and restore cursor
        if wasFirstResponder {
            resignFirstResponder()
            becomeFirstResponder()
        }
        text = currentText
        if let range = selectedRange {
            selectedTextRange = range
        }
        let imageName = isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        eyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
