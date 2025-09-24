import UIKit

final class CheckInViewController: UIViewController {
    private let storage: StorageService
    private let riskEngine: RiskEngine
    
    // UI
    private lazy var moodSlider: UISlider = {
        let s = UISlider();
        s.minimumValue = 0;
        s.maximumValue = 10;
        s.tintColor = .secondaryC
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private lazy var cravingSlider: UISlider = {
        let s = UISlider()
        s.minimumValue = 0
        s.maximumValue = 10
        s.tintColor = .secondaryC
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private let sleepRanges = ["3-4 horas", "5-7 horas", "8\nhoras", "Más de 8 horas"]
    private lazy var sleepRangeStack: UIStackView = {
        let s = UIStackView.h(8)
        s.alignment = .center
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    private var selectedSleepRange: String?
    private let triggerOptions = ["Estrés","Conflicto","Lugares", "Personas", "Falta de sueño","Dolor"]
    private lazy var triggersStack: UIStackView = { let s = UIStackView.v(8); s.alignment = .leading; s.translatesAutoresizingMaskIntoConstraints = false; return s }()
    private lazy var notesView: UITextView = {
        let v = UITextView();
        v.layer.cornerRadius = 12;
        v.layer.borderWidth = 1;
        v.layer.borderColor = UIColor.separator.cgColor;
        let padding: CGFloat = 12
        v.font = .systemFont(ofSize: 16)
        v.contentInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        v.translatesAutoresizingMaskIntoConstraints = false;
        v.heightAnchor.constraint(equalToConstant: 100).isActive = true;
        return v
    }()
    private lazy var saveButton: UIButton = {
        var config = UIButton.Configuration.bordered()
        config.baseBackgroundColor = .primaryC
        config.baseForegroundColor = .white
        config.title = "Guardar"
        config.buttonSize = .large
        let b = UIButton(configuration: config, primaryAction: UIAction {
            _ in self.saveTap()
        })
        b.translatesAutoresizingMaskIntoConstraints = false;
        return b
    }()
    
    // Mood faces
    private let moodFaces: [(emoji: String, value: Int)] = [
        ("😞", 0), ("😐", 2), ("🙂", 5), ("😃", 8), ("🤩", 10)
    ]
    private lazy var moodFaceStack: UIStackView = {
        let stack = UIStackView.h(12)
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        moodFaces.forEach { face in
            let label = UILabel()
            label.text = face.emoji
            label.font = .systemFont(ofSize: 32)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(moodFaceTapped(_:)))
            label.addGestureRecognizer(tap)
            stack.addArrangedSubview(label)
        }
        return stack
    }()
    
    // Craving faces
    private let cravingFaces: [(emoji: String, value: Int)] = [
        ("😌", 0), ("🙂", 2), ("😐", 5), ("😣", 8), ("😫", 10)
    ]
    private lazy var cravingFaceStack: UIStackView = {
        let stack = UIStackView.h(12)
        stack.alignment = .center
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        cravingFaces.forEach { face in
            let label = UILabel()
            label.text = face.emoji
            label.font = .systemFont(ofSize: 32)
            label.textAlignment = .center
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(cravingFaceTapped(_:)))
            label.addGestureRecognizer(tap)
            stack.addArrangedSubview(label)
        }
        return stack
    }()
    
    init(storage: StorageService, riskEngine: RiskEngine) {
        self.storage = storage; self.riskEngine = riskEngine
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Como me siento Hoy"
        view.backgroundColor = .systemBackground
        setupHierarchy(); buildTriggerChips()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        moodSlider.addTarget(self, action: #selector(moodSliderChanged), for: .valueChanged)
        cravingSlider.addTarget(self, action: #selector(cravingSliderChanged), for: .valueChanged)
        updateMoodFaces()
        updateCravingFaces()
    }
    
    private func setupHierarchy() {
        let stack = UIStackView.v(12); stack.translatesAutoresizingMaskIntoConstraints = false
        let moodLbl = UILabel(); moodLbl.text = "Estado de Ánimo:"; moodLbl.font = .boldSystemFont(ofSize: 16)
        let cravingLbl = UILabel(); cravingLbl.text = "Nivel de Craving(Antojo) (0–10)"; cravingLbl.font = .boldSystemFont(ofSize: 16)
        let sleepLbl = UILabel(); sleepLbl.text = "Horas de sueño"; sleepLbl.font = .boldSystemFont(ofSize: 16)
        let triggersLbl = UILabel(); triggersLbl.text = "Detonantes"; triggersLbl.font = .boldSystemFont(ofSize: 16)
        let notesLbl = UILabel(); notesLbl.text = "Notas"; notesLbl.font = .boldSystemFont(ofSize: 16)
        view.addSubview(stack)
        stack.addArrangedSubview(moodLbl)
        stack.addArrangedSubview(moodFaceStack)
        stack.addArrangedSubview(moodSlider)
        stack.addArrangedSubview(cravingLbl)
        stack.addArrangedSubview(cravingFaceStack)
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
        let chipsPerRow = 2
        let rows = stride(from: 0, to: sleepRanges.count, by: chipsPerRow).map {
            Array(sleepRanges[$0..<min($0+chipsPerRow, sleepRanges.count)])
        }
        rows.forEach { rowOptions in
            let rowStack = UIStackView.h(8)
            rowStack.alignment = .center
            rowOptions.forEach { range in
                let b = PillButton(type: .system)
                b.setTitle(range, for: .normal)
                b.isSelected = selectedSleepRange == range
                b.addAction(UIAction(handler: { [weak self, weak b] _ in
                    self?.selectSleepRange(range, button: b)
                }), for: .touchUpInside)
                rowStack.addArrangedSubview(b)
            }
            sleepRangeStack.addArrangedSubview(rowStack)
        }
    }

    private func selectSleepRange(_ range: String, button: UIButton?) {
        selectedSleepRange = range
        sleepRangeStack.arrangedSubviews.forEach { row in
            guard let rowStack = row as? UIStackView else { return }
            rowStack.arrangedSubviews.forEach {
                ($0 as? UIButton)?.isSelected = ($0 as? UIButton)?.title(for: .normal) == range
            }
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
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func saveTap() {
        dismissKeyboard()
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
    
    @objc private func moodSliderChanged() {
        updateMoodFaces()
    }
    
    private func updateMoodFaces() {
        let value = Int(moodSlider.value.rounded())
        for (i, face) in moodFaces.enumerated() {
            guard let label = moodFaceStack.arrangedSubviews[i] as? UILabel else { continue }
            // Highlight the closest face
            let isSelected = value >= face.value && (i == moodFaces.count - 1 || value < moodFaces[i+1].value)
            label.alpha = isSelected ? 1.0 : 0.4
            label.transform = isSelected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
        }
    }

    @objc private func moodFaceTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let index = moodFaceStack.arrangedSubviews.firstIndex(of: label) else { return }
        let value = moodFaces[index].value
        moodSlider.setValue(Float(value), animated: true)
        updateMoodFaces()
    }
    
    @objc private func cravingSliderChanged() {
        updateCravingFaces()
    }

    private func updateCravingFaces() {
        let value = Int(cravingSlider.value.rounded())
        for (i, face) in cravingFaces.enumerated() {
            guard let label = cravingFaceStack.arrangedSubviews[i] as? UILabel else { continue }
            let isSelected = value >= face.value && (i == cravingFaces.count - 1 || value < cravingFaces[i+1].value)
            label.alpha = isSelected ? 1.0 : 0.4
            label.transform = isSelected ? CGAffineTransform(scaleX: 1.2, y: 1.2) : .identity
        }
    }

    @objc private func cravingFaceTapped(_ sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel,
              let index = cravingFaceStack.arrangedSubviews.firstIndex(of: label) else { return }
        let value = cravingFaces[index].value
        cravingSlider.setValue(Float(value), animated: true)
        updateCravingFaces()
    }
}
