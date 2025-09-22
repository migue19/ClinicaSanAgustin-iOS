
import UIKit

final class PlanActionViewController: UIViewController {
    private lazy var stack: UIStackView = { let s = UIStackView.v(12); s.translatesAutoresizingMaskIntoConstraints = false; return s }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Plan de acción"
        view.backgroundColor = .systemBackground

        let tips = [
            "Respiración 4‑7‑8: Inhala 4s, mantén 7s, exhala 8s (4 veces).",
            "Grounding 5‑4‑3‑2‑1: nombra 5 cosas que ves, 4 que sientes, 3 que oyes, 2 que hueles, 1 que saboreas.",
            "Contacta a tu apoyo: llama a un familiar o terapeuta.",
            "Distracción breve: camina 10 minutos o toma agua."
        ]

        let stack = UIStackView.v(12); stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        let info = UILabel(); info.numberOfLines = 0; info.text = "Usa estas estrategias cuando notes craving alto o ánimo muy bajo:"
        info.font = .systemFont(ofSize: 16, weight: .semibold)
        stack.addArrangedSubview(info)

        for t in tips {
            let l = UILabel(); l.numberOfLines = 0; l.text = "• " + t
            stack.addArrangedSubview(l)
        }

        let btn = UIButton(type: .system); btn.setTitle("Contactar clínica", for: .normal)
        btn.addAction(UIAction(handler: { [weak self] _ in
            let a = UIAlertController(title: "Contacto", message: "Simular llamada / WhatsApp aquí.", preferredStyle: .alert)
            a.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(a, animated: true)
        }), for: .touchUpInside)
        stack.addArrangedSubview(btn)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}
