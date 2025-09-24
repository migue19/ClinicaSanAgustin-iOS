import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let storage: StorageService
    private let riskEngine: RiskEngine
    private var isAuthenticated = false

    init(navigationController: UINavigationController, storage: StorageService, riskEngine: RiskEngine) {
        self.navigationController = navigationController
        self.storage = storage
        self.riskEngine = riskEngine
    }

    func start() {
        showLogin()
    }

    private func showLogin() {
        let loginVC = LoginViewController()
        loginVC.onLoginSuccess = { [weak self] in self?.showMainTabBar() }
        loginVC.onShowRegister = { [weak self] in self?.showRegister() }
        navigationController.setViewControllers([loginVC], animated: false)
    }

    private func showRegister() {
        let registerVC = RegisterViewController()
        registerVC.onRegisterSuccess = { [weak self] in self?.showMainTabBar() }
        registerVC.onShowLogin = { [weak self] in self?.showLogin() }
        navigationController.pushViewController(registerVC, animated: true)
    }

    private func showMainTabBar() {
        let tabBar = MainTabBarController()
        navigationController.setViewControllers([tabBar], animated: true)
    }
}
