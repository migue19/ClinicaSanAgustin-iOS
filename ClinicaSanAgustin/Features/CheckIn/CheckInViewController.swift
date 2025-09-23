import UIKit

final class CheckInViewController: UIViewController {
    private let storage: StorageService
    private let riskEngine: RiskEngine
    
    // UI
    private lazy var moodSlider: UISlider = { let s = UISlider(); s.minimumValue = 0; s.maximumValue = 10; s.translatesAutoresizingMaskIntoConstraints = false; return s }()
    private lazy var cravingSlider: UISlider = { let s = UISlider(); s.minimumValue = 0; s.maximumValue = 10; s.translatesAutoresizingMaskIntoConstraints = false; return s }()
    private let sleepRanges = ["3-4 horas", "5-7 horas", "más de 8 horas"]
    private lazy var sleepRangeStack: UIStackView = {
        let s = UIStackView.h(8)
        s.alignment = .center
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private var selectedSleepRange: String?
    private let triggerOptions = ["Estrés","Conflicto","Lugares","Personas","Sueño pobre","Dolor"]
    private lazy var triggersStack: UIStackView = { let s = UIStackView.h(8); s.alignment = .leading; s.translatesAutoresizingMaskIntoConstraints = false; return s }()
    private lazy var notesView: UITextView = {
        let v = UITextView(); v.layer.cornerRadius = 12; v.layer.borderWidth = 1; v.layer.borderColor = UIColor.separator.cgColor; v.translatesAutoresizingMaskIntoConstraints = false; v.heightAnchor.constraint(equalToConstant: 100).isActive = true; return v
    }()
    private lazy var saveButton: UIButton = { let b = UIButton(type: .system); b.setTitle("Guardar check‑in", for: .normal); b.addTarget(self, action: #selector(saveTap), for: .touchUpInside); b.translatesAutoresizingMaskIntoConstraints = false; return b }()
    
    init(storage: StorageService, riskEngine: RiskEngine) {
        self.storage = storage; self.riskEngine = riskEngine
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Check‑in"
        view.backgroundColor = .systemBackground
        setupHierarchy(); buildTriggerChips()
    }
    
    private func setupHierarchy() {
        let stack = UIStackView.v(12); stack.translatesAutoresizingMaskIntoConstraints = false
        let moodLbl = UILabel(); moodLbl.text = "Ánimo (0–10)"; moodLbl.font = .boldSystemFont(ofSize: 16)
        let cravingLbl = UILabel(); cravingLbl.text = "Craving (0–10)"; cravingLbl.font = .boldSystemFont(ofSize: 16)
        let sleepLbl = UILabel(); sleepLbl.text = "Horas de sueño"; sleepLbl.font = .boldSystemFont(ofSize: 16)
        let triggersLbl = UILabel(); triggersLbl.text = "Gatillantes"; triggersLbl.font = .boldSystemFont(ofSize: 16)
        let notesLbl = UILabel(); notesLbl.text = "Notas"; notesLbl.font = .boldSystemFont(ofSize: 16)
        
        view.addSubview(stack)
        stack.addArrangedSubview(moodLbl)
        stack.addArrangedSubview(moodSlider)
        stack.addArrangedSubview(cravingLbl)
        stack.addArrangedSubview(cravingSlider)
        stack.addArrangedSubview(sleepLbl)
        stack.addArrangedSubview(sleepRangeStack)
        stack.addArrangedSubview(triggersLbl)
        stack.addArrangedSubview(triggersStack)
        stack.addArrangedSubview(notesLbl)
        stack.addArrangedSubview(notesView)
        stack.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        buildSleepRangeChips()
    }
    
    private func buildSleepRangeChips() {
        sleepRangeStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        sleepRanges.forEach { range in
            let b = PillButton(type: .system)
            b.setTitle(range, for: .normal)
            b.addAction(UIAction(handler: { [weak self, weak b] _ in
                self?.selectSleepRange(range, button: b)
            }), for: .touchUpInside)
            sleepRangeStack.addArrangedSubview(b)
        }
    }
    
    private func selectSleepRange(_ range: String, button: UIButton?) {
        selectedSleepRange = range
        sleepRangeStack.arrangedSubviews.forEach {
            ($0 as? UIButton)?.isSelected = ($0 as? UIButton)?.title(for: .normal) == range
        }
    }
    
    private func buildTriggerChips() {
        triggersStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let chipsPerRow = 3
        let rows = stride(from: 0, to: triggerOptions.count, by: chipsPerRow).map {
            Array(triggerOptions[$0..<min($0+chipsPerRow, triggerOptions.count)])
        }
        rows.forEach { rowOptions in
            let rowStack = UIStackView.h(8)
            rowStack.alignment = .leading
            rowOptions.forEach { name in
                let b = PillButton(type: .system)
                b.setTitle(name, for: .normal)
                b.addAction(UIAction(handler: { [weak b] _ in b?.isSelected.toggle() }), for: .touchUpInside)
                rowStack.addArrangedSubview(b)
            }
            triggersStack.addArrangedSubview(rowStack)
        }
    }
    
    @objc private func saveTap() {
        let mood = Int(moodSlider.value.rounded())
        let craving = Int(cravingSlider.value.rounded())
        // Map sleep range to representative value
        let sleep: Int = {
            switch selectedSleepRange {
            case "3-4 horas": return 4
            case "5-7 horas": return 6
            case "más de 8 horas": return 8
            default: return 0
            }
        }()
        let selected = triggersStack.arrangedSubviews.compactMap { ($0 as? UIButton)?.isSelected == true ? ($0 as? UIButton)?.title(for: .normal) : nil }
        let check = CheckIn(id: UUID().uuidString, date: Date(), mood: mood, craving: craving, sleepHours: sleep, triggers: selected, notes: notesView.text)
        storage.save(checkIn: check)
        let flag = riskEngine.evaluate(checkIn: check)
        let msg = flag.reasons.isEmpty ? "Check‑in guardado." : "Nivel: \(flag.level.rawValue.uppercased())\n\(flag.reasons.joined(separator: ", "))"
        let alert = UIAlertController(title: "Listo", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
