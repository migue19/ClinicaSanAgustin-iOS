import UIKit

final class LoginViewController: UIViewController {
    var onLoginSuccess: (() -> Void)?
    var onShowRegister: (() -> Void)?

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "logo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    private let emailField: UITextField = {
        let f = UITextField();
        f.placeholder = "Correo electrónico";
        f.borderStyle = .roundedRect;
        f.autocapitalizationType = .none;
        f.text = "someuser@example.com"
        return f
    }()
    private let passwordField: UITextField = {
        let f = UITextField(); f.placeholder = "Contraseña"; f.borderStyle = .roundedRect;
        f.isSecureTextEntry = true;
        f.text = "password123"
        return f
    }()
    private let loginButton: PrimaryButton = {
        let b = PrimaryButton(title: "Iniciar sesión")
        return b
    }()
    private let registerButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Registrarse", for: .normal); b.translatesAutoresizingMaskIntoConstraints = false; return b
    }()
    private let emailLabel: UILabel = {
        let l = UILabel(); l.text = "Correo electrónico"; l.font = .systemFont(ofSize: 14, weight: .medium); l.textColor = .secondaryLabel; return l
    }()
    private let passwordLabel: UILabel = {
        let l = UILabel(); l.text = "Contraseña"; l.font = .systemFont(ofSize: 14, weight: .medium); l.textColor = .secondaryLabel; return l
    }()
    private let passwordEyeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "eye"), for: .normal)
        b.tintColor = .secondaryLabel
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Iniciar sesión"
        setupUI()
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func setupUI() {
        let passwordStack = UIStackView(arrangedSubviews: [passwordField, passwordEyeButton])
        passwordStack.axis = .horizontal
        passwordStack.spacing = 8
        passwordStack.translatesAutoresizingMaskIntoConstraints = false
        passwordField.rightView = passwordEyeButton
        passwordField.rightViewMode = .always
        let stack = UIStackView(arrangedSubviews: [logoImageView, emailLabel, emailField, passwordLabel, passwordStack, loginButton, registerButton])
        stack.axis = .vertical; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        loginButton.addTarget(self, action: #selector(loginTap), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
        passwordEyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
    }

    @objc private func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func loginTap() {
        hideKeyboard()
        // Dummy authentication logic
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert("Por favor ingresa correo y contraseña")
            return
        }
        // Simulate success
        onLoginSuccess?()
    }

    @objc private func registerTap() {
        onShowRegister?()
    }

    @objc private func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye" : "eye.slash"
        passwordEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
