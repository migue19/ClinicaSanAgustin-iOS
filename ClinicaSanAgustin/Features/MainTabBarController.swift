import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    private func setupTabs() {
        let homeVC = HomeViewController(storage: StorageService(), riskEngine: RiskEngine())
        homeVC.tabBarItem = UITabBarItem(title: "Inicio", image: UIImage(systemName: "house"), tag: 0)
        let appointmentVC = AppointmentRequestViewController(storage: StorageService())
        appointmentVC.tabBarItem = UITabBarItem(title: "Citas", image: UIImage(systemName: "calendar"), tag: 1)
        let planVC = PlanActionViewController()
        planVC.tabBarItem = UITabBarItem(title: "Plan", image: UIImage(systemName: "lightbulb"), tag: 2)
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), tag: 3)
        profileVC.onLogout = { [weak self] in
            self?.handleLogout()
        }
        viewControllers = [homeVC, appointmentVC, planVC, profileVC]
    }

    private func handleLogout() {
        // Notify coordinator or present login screen
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            let nav = UINavigationController()
            let coordinator = AppCoordinator(navigationController: nav, storage: StorageService(), riskEngine: RiskEngine())
            coordinator.start()
            window.rootViewController = nav
            window.makeKeyAndVisible()
        }
    }
}
