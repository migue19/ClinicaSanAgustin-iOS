
import Foundation

final class RiskEngine {
    func evaluate(checkIn: CheckIn) -> RiskFlag {
        var reasons: [String] = []
        var level: RiskLevel = .none

        if checkIn.craving >= 8 { level = .red; reasons.append("Craving ≥ 8") }
        if checkIn.mood <= 2 { level = .red; reasons.append("Ánimo ≤ 2") }
        if checkIn.mood <= 4 && checkIn.sleepHours < 5 {
            if level == .none { level = .amber }
            reasons.append("Ánimo bajo + poco sueño")
        }
        return RiskFlag(level: level, reasons: reasons)
    }
}
