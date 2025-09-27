
import UIKit

final class AppointmentRequestViewController: UIViewController {
    private let storage: StorageService

    private lazy var reasonField: UITextField = { let t = UITextField(); t.placeholder = "Motivo"; t.borderStyle = .roundedRect; t.translatesAutoresizingMaskIntoConstraints = false; return t }()
    private lazy var modalityControl: UISegmentedControl = { let c = UISegmentedControl(items: ["Presencial","Virtual"]); c.selectedSegmentIndex = 0; c.translatesAutoresizingMaskIntoConstraints = false; return c }()
    private lazy var urgencyControl: UISegmentedControl = { let c = UISegmentedControl(items: ["Alta","Media","Baja"]); c.selectedSegmentIndex = 1; c.translatesAutoresizingMaskIntoConstraints = false; return c }()
    private lazy var datePicker: UIDatePicker = { let p = UIDatePicker(); p.datePickerMode = .dateAndTime; p.preferredDatePickerStyle = .compact; p.translatesAutoresizingMaskIntoConstraints = false; return p }()
    private lazy var addDateButton: UIButton = { let b = UIButton(type: .system); b.setTitle("Agregar horario preferido", for: .normal); b.addTarget(self, action: #selector(addPreferredDate), for: .touchUpInside); b.translatesAutoresizingMaskIntoConstraints = false; return b }()
    private lazy var selectedDatesLabel: UILabel = { let l = UILabel(); l.numberOfLines = 0; l.textColor = .secondaryLabel; l.translatesAutoresizingMaskIntoConstraints = false; l.text = "Sin horarios agregados"; return l }()
    private lazy var sendButton: UIButton = { let b = UIButton(type: .system); b.setTitle("Enviar solicitud", for: .normal); b.addTarget(self, action: #selector(sendTap), for: .touchUpInside); b.translatesAutoresizingMaskIntoConstraints = false; return b }()

    private var preferredDates: [Date] = [] { didSet { updateDatesLabel() } }

    init(storage: StorageService) { self.storage = storage; super.init(nibName: nil, bundle: nil) }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Solicitar consulta"
        view.backgroundColor = .systemBackground
        setup()
    }

    private func setup() {
        let stack = UIStackView.v(12); stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.addArrangedSubview(reasonField)
        stack.addArrangedSubview(modalityControl)
        stack.addArrangedSubview(urgencyControl)
        stack.addArrangedSubview(datePicker)
        stack.addArrangedSubview(addDateButton)
        stack.addArrangedSubview(selectedDatesLabel)
        stack.addArrangedSubview(sendButton)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func updateDatesLabel() {
        let df = DateFormatter(); df.dateStyle = .medium; df.timeStyle = .short
        let text = preferredDates.map { "• " + df.string(from: $0) }.joined(separator: "\n")
        selectedDatesLabel.text = text.isEmpty ? "Sin horarios agregados" : text
    }

    @objc private func addPreferredDate() { preferredDates.append(datePicker.date) }

    @objc private func sendTap() {
        let reason = reasonField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        guard !reason.isEmpty else { show("Escribe un motivo, por favor."); return }
        let modality: Modality = (modalityControl.selectedSegmentIndex == 0) ? .presencial : .virtual
        let urg: Urgency = [Urgency.alta, .media, .baja][urgencyControl.selectedSegmentIndex]
        let req = AppointmentRequest(id: UUID().uuidString, createdAt: Date(), reason: reason, modality: modality, urgency: urg, preferredDates: preferredDates)
        storage.save(appointment: req)
        show("Solicitud enviada. Nos pondremos en contacto para confirmar.")
    }

    private func show(_ msg: String) {
        let a = UIAlertController(title: "Listo", message: msg, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}
