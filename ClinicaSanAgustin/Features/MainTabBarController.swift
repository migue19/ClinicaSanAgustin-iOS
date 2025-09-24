import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }

    // Use lazy properties for tabs to avoid repeated instantiation
    private lazy var estadoVC: EstadoViewController = {
        let vc = EstadoViewController()
        vc.tabBarItem = UITabBarItem(title: "Estado", image: UIImage(systemName: "chart.bar"), tag: 0)
        return vc
    }()
    private lazy var appointmentVC: AppointmentRequestViewController = {
        let vc = AppointmentRequestViewController(storage: StorageService())
        vc.tabBarItem = UITabBarItem(title: "Citas", image: UIImage(systemName: "calendar"), tag: 1)
        return vc
    }()
    private lazy var homeVC: HomeViewController = {
        let vc = HomeViewController(storage: StorageService(), riskEngine: RiskEngine())
        vc.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 2)
        return vc
    }()
    private lazy var planVC: PlanActionViewController = {
        let vc = PlanActionViewController()
        vc.tabBarItem = UITabBarItem(title: "Plan", image: UIImage(systemName: "lightbulb"), tag: 3)
        return vc
    }()
    private lazy var profileVC: ProfileViewController = {
        let vc = ProfileViewController()
        vc.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person"), tag: 4)
        vc.onLogout = { [weak self] in self?.handleLogout() }
        return vc
    }()

    private func setupTabs() {
        viewControllers = [estadoVC, appointmentVC, homeVC, planVC, profileVC]
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
