import UIKit

final class LoginViewController: UIViewController {
    var onLoginSuccess: (() -> Void)?
    var onShowRegister: (() -> Void)?

    private let emailField: UITextField = {
        let f = UITextField(); f.placeholder = "Correo electrónico"; f.borderStyle = .roundedRect; f.autocapitalizationType = .none; return f
    }()
    private let passwordField: UITextField = {
        let f = UITextField(); f.placeholder = "Contraseña"; f.borderStyle = .roundedRect; f.isSecureTextEntry = true; return f
    }()
    private let loginButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Iniciar sesión", for: .normal); b.translatesAutoresizingMaskIntoConstraints = false; return b
    }()
    private let registerButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Registrarse", for: .normal); b.translatesAutoresizingMaskIntoConstraints = false; return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Iniciar sesión"
        setupUI()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, loginButton, registerButton])
        stack.axis = .vertical; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        loginButton.addTarget(self, action: #selector(loginTap), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
    }

    @objc private func loginTap() {
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

    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
