import UIKit
import FirebaseAuth

final class RegisterViewController: BaseController {
    var onRegisterSuccess: (() -> Void)?
    var onShowLogin: (() -> Void)?

    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Crear cuenta"
        l.font = .systemFont(ofSize: 24, weight: .bold)
        l.textAlignment = .center
        return l
    }()

    private lazy var nameLabel: UILabel = {
        let l = UILabel()
        l.text = "Nombre"
        l.font = .systemFont(ofSize: 16, weight: .medium)
        return l
    }()

    private lazy var nameField: UITextField = {
        let f = UITextField()
        f.placeholder = "Ingresa tu nombre"
        f.borderStyle = .roundedRect
        f.autocapitalizationType = .words
        return f
    }()

    private lazy var emailLabel: UILabel = {
        let l = UILabel()
        l.text = "Correo electrónico"
        l.font = .systemFont(ofSize: 16, weight: .medium)
        return l
    }()

    private lazy var emailField: UITextField = {
        let f = UITextField()
        f.placeholder = "Ingresa tu correo"
        f.borderStyle = .roundedRect
        f.autocapitalizationType = .none
        return f
    }()

    private lazy var passwordLabel: UILabel = {
        let l = UILabel()
        l.text = "Contraseña"
        l.font = .systemFont(ofSize: 16, weight: .medium)
        return l
    }()

    private lazy var passwordField: PasswordTextField = {
        let f = PasswordTextField()
        f.placeholder = "Crea una contraseña"
        return f
    }()

    private lazy var confirmLabel: UILabel = {
        let l = UILabel()
        l.text = "Confirmar contraseña"
        l.font = .systemFont(ofSize: 16, weight: .medium)
        return l
    }()

    private lazy var confirmField: PasswordTextField = {
        let f = PasswordTextField()
        f.placeholder = "Repite tu contraseña"
        return f
    }()

    private lazy var registerButton: PrimaryButton = {
        let b = PrimaryButton(title: "Registrate")
        return b
    }()

    private lazy var googleButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Registrarse con Google"
        config.baseBackgroundColor = .lightGray.withAlphaComponent(0.4)
        config.baseForegroundColor = .black
        config.cornerStyle = .capsule
        config.titleAlignment = .center
        config.imagePadding = 8
        if let googleIcon = UIImage(named: "ic_google") {
            config.image = googleIcon.withRenderingMode(.alwaysOriginal)
        }
        config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let b = UIButton(configuration: config)
        b.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return b
    }()

    private lazy var loginButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Ya tengo cuenta", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Registro"
        setupUI()
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            nameLabel, nameField,
            emailLabel, emailField,
            passwordLabel, passwordField,
            confirmLabel, confirmField,
            registerButton,
            googleButton,
            loginButton
        ])
        stack.axis = .vertical
        stack.spacing = 8
        stack.setCustomSpacing(16, after: titleLabel)
        stack.setCustomSpacing(40, after: confirmField)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stack.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -16),
        ])
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleRegisterTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTap), for: .touchUpInside)
    }

    @objc private func registerTap() {
        guard let name = nameField.text, !name.isEmpty,
              let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let confirm = confirmField.text, password == confirm else {
            showAlert("Completa todos los campos y asegúrate que las contraseñas coincidan")
            return
        }
        registerButton.isEnabled = false
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                self?.registerButton.isEnabled = true
                if let error = error {
                    self?.showAlert(error.localizedDescription)
                    return
                }
                // Optionally update displayName
                if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                    changeRequest.displayName = name
                    changeRequest.commitChanges { _ in }
                }
                self?.onRegisterSuccess?()
            }
        }
    }

    @objc private func googleRegisterTap() {
        // TODO: Implement Google Sign-In logic here
        showAlert("Funcionalidad de registro con Google próximamente disponible.")
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
