
import UIKit

final class HomeViewController: UIViewController {
    // Callbacks
    var onOpenCheckIn: (() -> Void)?
    var onOpenAppointment: (() -> Void)?
    var onOpenPlanAction: (() -> Void)?

    private let storage: StorageService
    private let riskEngine: RiskEngine

    // UI
    private lazy var scrollView: UIScrollView = {
        let v = UIScrollView(); v.translatesAutoresizingMaskIntoConstraints = false; return v
    }()

    private lazy var contentStack: UIStackView = {
        let s = UIStackView.v(12); s.translatesAutoresizingMaskIntoConstraints = false
        s.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        s.isLayoutMarginsRelativeArrangement = true
        return s
    }()

    private func card(title: String, subtitle: String?, action: Selector) -> UIView {
        let v = UIView(); v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .secondarySystemBackground; v.layer.cornerRadius = 16
        let t = UILabel(); t.font = .boldSystemFont(ofSize: 18); t.text = title
        let s = UILabel(); s.font = .systemFont(ofSize: 14); s.textColor = .secondaryLabel; s.numberOfLines = 0; s.text = subtitle
        let b = UIButton(type: .system); b.setTitle("Abrir", for: .normal); b.addTarget(self, action: action, for: .touchUpInside)
        let stack = UIStackView.v(8)
        stack.addArrangedSubview(t); if let subtitle = subtitle { s.text = subtitle; stack.addArrangedSubview(s) }
        stack.addArrangedSubview(b)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        v.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: v.topAnchor),
            stack.leadingAnchor.constraint(equalTo: v.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: v.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: v.bottomAnchor)
        ])
        return v
    }

    init(storage: StorageService, riskEngine: RiskEngine) {
        self.storage = storage; self.riskEngine = riskEngine
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "San Agustín – Paciente"
        view.backgroundColor = .systemBackground
        setupHierarchy(); setupConstraints()
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        contentStack.addArrangedSubview(card(title: "Check‑in de hoy", subtitle: "Registra ánimo, craving y sueño.", action: #selector(openCheckIn)))
        contentStack.addArrangedSubview(card(title: "Solicitar consulta", subtitle: "Pide una cita presencial o virtual.", action: #selector(openAppointment)))
        contentStack.addArrangedSubview(card(title: "Plan de acción", subtitle: "Estrategias rápidas ante craving.", action: #selector(openPlanAction)))
        // Últimos check‑ins
        let recent = storage.loadCheckIns().prefix(5)
        if !recent.isEmpty {
            let box = UIView(); box.translatesAutoresizingMaskIntoConstraints = false; box.backgroundColor = .secondarySystemBackground; box.layer.cornerRadius = 16
            let title = UILabel(); title.text = "Últimos check‑ins"; title.font = .boldSystemFont(ofSize: 18)
            let stack = UIStackView.v(6); stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(title)
            let df = DateFormatter(); df.dateStyle = .medium; df.timeStyle = .short
            for c in recent {
                let l = UILabel()
                let flag = riskEngine.evaluate(checkIn: c).level
                l.text = "• " + df.string(from: c.date) + "  –  Ánimo: \(c.mood), Craving: \(c.craving) [\(flag.rawValue.uppercased())]"
                l.font = .systemFont(ofSize: 14)
                stack.addArrangedSubview(l)
            }
            stack.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            stack.isLayoutMarginsRelativeArrangement = true
            box.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: box.topAnchor),
                stack.leadingAnchor.constraint(equalTo: box.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: box.trailingAnchor),
                stack.bottomAnchor.constraint(equalTo: box.bottomAnchor)
            ])
            contentStack.addArrangedSubview(box)
        }
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
    }

    // MARK: Actions
    @objc private func openCheckIn() { onOpenCheckIn?() }
    @objc private func openAppointment() { onOpenAppointment?() }
    @objc private func openPlanAction() { onOpenPlanAction?() }
}
