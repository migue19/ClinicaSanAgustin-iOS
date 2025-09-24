import UIKit

final class RegisterViewController: UIViewController {
    var onRegisterSuccess: (() -> Void)?
    var onShowLogin: (() -> Void)?

    private let emailField: UITextField = {
        let f = UITextField(); f.placeholder = "Correo electrónico"; f.borderStyle = .roundedRect; f.autocapitalizationType = .none; return f
    }()
    private let passwordField: UITextField = {
        let f = UITextField(); f.placeholder = "Contraseña"; f.borderStyle = .roundedRect; f.isSecureTextEntry = true; return f
    }()
    private let confirmField: UITextField = {
        let f = UITextField(); f.placeholder = "Confirmar contraseña"; f.borderStyle = .roundedRect; f.isSecureTextEntry = true; return f
    }()
    private let registerButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Registrarse", for: .normal); b.translatesAutoresizingMaskIntoConstraints = false; return b
    }()
    private let loginButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Ya tengo cuenta", for: .normal); b.translatesAutoresizingMaskIntoConstraints = false; return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Registro"
        setupUI()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField, confirmField, registerButton, loginButton])
        stack.axis = .vertical; stack.spacing = 16; stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTap), for: .touchUpInside)
    }

    @objc private func registerTap() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let confirm = confirmField.text, password == confirm else {
            showAlert("Completa todos los campos y asegúrate que las contraseñas coincidan")
            return
        }
        // Simulate success
        onRegisterSuccess?()
    }

    @objc private func loginTap() {
        onShowLogin?()
    }

    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
