import UIKit

final class ProfileViewController: UIViewController {
    var onLogout: (() -> Void)?

    private let logoutButton: PillButton = {
        let b = PillButton(type: .system)
        b.setTitle("Cerrar sesión", for: .normal)
        b.isSelected = true
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Perfil"
        setupUI()
    }

    private func setupUI() {
        view.addSubview(logoutButton)
        NSLayoutConstraint.activate([
            logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoutButton.widthAnchor.constraint(equalToConstant: 200),
            logoutButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        logoutButton.addTarget(self, action: #selector(logoutTap), for: .touchUpInside)
    }

    @objc private func logoutTap() {
        onLogout?()
    }
}
