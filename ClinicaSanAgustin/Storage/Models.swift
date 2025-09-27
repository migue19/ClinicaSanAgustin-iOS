
import Foundation

enum Modality: String, Codable { case presencial, virtual }
enum Urgency: String, Codable { case alta, media, baja }

struct CheckIn: Codable, Identifiable {
    let id: String
    let date: Date
    var mood: Int        // 0..10
    var craving: Int     // 0..10
    var sleepHours: Int  // 0..24
    var triggers: [String]
    var notes: String?
}

struct AppointmentRequest: Codable, Identifiable {
    let id: String
    var createdAt: Date
    var reason: String
    var modality: Modality
    var urgency: Urgency
    var preferredDates: [Date]
}

struct RiskFlag: Codable {
    var level: RiskLevel
    var reasons: [String]
}

enum RiskLevel: String, Codable { case none, amber, red }
