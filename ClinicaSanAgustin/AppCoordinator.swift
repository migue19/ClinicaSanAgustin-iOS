
import UIKit

final class AppCoordinator {
    private let navigationController: UINavigationController
    private let storage: StorageService
    private let riskEngine: RiskEngine

    init(navigationController: UINavigationController, storage: StorageService, riskEngine: RiskEngine) {
        self.navigationController = navigationController
        self.storage = storage
        self.riskEngine = riskEngine
    }

    func start() {
        let vc = HomeViewController(storage: storage, riskEngine: riskEngine)
        vc.onOpenCheckIn = { [weak self] in self?.openCheckIn() }
        vc.onOpenAppointment = { [weak self] in self?.openAppointment() }
        vc.onOpenPlanAction = { [weak self] in self?.openPlanAction() }
        navigationController.setViewControllers([vc], animated: false)
    }

    private func openCheckIn() {
        let vc = CheckInViewController(storage: storage, riskEngine: riskEngine)
        navigationController.pushViewController(vc, animated: true)
    }

    private func openAppointment() {
        let vc = AppointmentRequestViewController(storage: storage)
        navigationController.pushViewController(vc, animated: true)
    }

    private func openPlanAction() {
        let vc = PlanActionViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
