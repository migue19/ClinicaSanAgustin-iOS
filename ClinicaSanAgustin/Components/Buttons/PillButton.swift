//
//  PillButton.swift
//  ClinicaSanAgustin
//
//  Created by Miguel Mexicano Herrera on 23/09/25.
//
import UIKit
final class PillButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) { super.init(coder: coder); setup() }
    private func setup() {
        var config = UIButton.Configuration.plain()
        config.cornerStyle = .capsule
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = .systemFont(ofSize: 14, weight: .medium)
            return outgoing
        }
        self.configuration = config
        layer.cornerRadius = 16
        layer.masksToBounds = true
        setTitleColor(.white, for: .selected)
        setTitleColor(.label, for: .normal)
        backgroundColor = .systemGray6
        titleLabel?.textAlignment = .center
    }
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .systemBlue : .systemGray6
        }
    }
}
