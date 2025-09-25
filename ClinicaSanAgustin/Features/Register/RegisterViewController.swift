import UIKit
import FirebaseAuth
final class RegisterViewController: BaseController {
    var onRegisterSuccess: (() -> Void)?
    var onShowLogin: (() -> Void)?

    private let titleLabel: UILabel = {
        let l = UILabel(); l.text = "Crear cuenta"; l.font = .systemFont(ofSize: 24, weight: .bold); l.textAlignment = .center; return l
    }()
    private let nameLabel: UILabel = {
        let l = UILabel(); l.text = "Nombre"; l.font = .systemFont(ofSize: 16, weight: .medium); return l
    }()
    private let nameField: UITextField = {
        let f = UITextField(); f.placeholder = "Ingresa tu nombre"; f.borderStyle = .roundedRect; f.autocapitalizationType = .words; return f
    }()
    private let emailLabel: UILabel = {
        let l = UILabel(); l.text = "Correo electrónico"; l.font = .systemFont(ofSize: 16, weight: .medium); return l
    }()
    private let emailField: UITextField = {
        let f = UITextField(); f.placeholder = "Ingresa tu correo"; f.borderStyle = .roundedRect; f.autocapitalizationType = .none; return f
    }()
    private let passwordLabel: UILabel = {
        let l = UILabel(); l.text = "Contraseña"; l.font = .systemFont(ofSize: 16, weight: .medium); return l
    }()
    private let passwordField: UITextField = {
        let f = UITextField(); f.placeholder = "Crea una contraseña"; f.borderStyle = .roundedRect; f.isSecureTextEntry = true; return f
    }()
    private let confirmLabel: UILabel = {
        let l = UILabel(); l.text = "Confirmar contraseña"; l.font = .systemFont(ofSize: 16, weight: .medium); return l
    }()
    private let confirmField: UITextField = {
        let f = UITextField(); f.placeholder = "Repite tu contraseña"; f.borderStyle = .roundedRect; f.isSecureTextEntry = true; return f
    }()
    private let registerButton: PrimaryButton = {
        let b = PrimaryButton(title: "Registrate")
        return b
    }()
    private let googleButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Registrarse con Google", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor(red: 219/255, green: 68/255, blue: 55/255, alpha: 1) // Google red
        b.layer.cornerRadius = 22
        b.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        b.heightAnchor.constraint(equalToConstant: 44).isActive = true
        if let googleIcon = UIImage(named: "google_icon") {
            b.setImage(googleIcon.withRenderingMode(.alwaysOriginal), for: .normal)
            b.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        }
        return b
    }()
    private let loginButton: UIButton = {
        let b = UIButton(type: .system); b.setTitle("Ya tengo cuenta", for: .normal); b.translatesAutoresizingMaskIntoConstraints = false; return b
    }()
    private let passwordEyeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        b.tintColor = .gray
        return b
    }()
    private let confirmEyeButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "eye.fill"), for: .normal)
        b.tintColor = .gray
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Registro"
        setupUI()
        setupPasswordEyes()
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
        //stack.setCustomSpacing(16, after: titleLabel)
        stack.setCustomSpacing(40, after: confirmField)
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
        registerButton.addTarget(self, action: #selector(registerTap), for: .touchUpInside)
        googleButton.addTarget(self, action: #selector(googleRegisterTap), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginTap), for: .touchUpInside)
    }

    private func setupPasswordEyes() {
        passwordEyeButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        confirmEyeButton.addTarget(self, action: #selector(toggleConfirmVisibility), for: .touchUpInside)
        passwordField.rightView = passwordEyeButton
        passwordField.rightViewMode = .always
        confirmField.rightView = confirmEyeButton
        confirmField.rightViewMode = .always
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

    @objc private func togglePasswordVisibility() {
        passwordField.isSecureTextEntry.toggle()
        let imageName = passwordField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        passwordEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    @objc private func toggleConfirmVisibility() {
        confirmField.isSecureTextEntry.toggle()
        let imageName = confirmField.isSecureTextEntry ? "eye.fill" : "eye.slash.fill"
        confirmEyeButton.setImage(UIImage(systemName: imageName), for: .normal)
    }

    private func showAlert(_ msg: String) {
        let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
