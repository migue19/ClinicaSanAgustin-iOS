
import Foundation

final class StorageService {
    private let checkInsKey = "checkins_v1"
    private let appointmentsKey = "appointments_v1"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init() {
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601
    }

    // MARK: Check‑ins
    func save(checkIn: CheckIn) {
        var all = loadCheckIns()
        if let idx = all.firstIndex(where: { $0.id == checkIn.id }) { all[idx] = checkIn } else { all.append(checkIn) }
        persist(all, key: checkInsKey)
    }

    func loadCheckIns() -> [CheckIn] {
        guard let data = UserDefaults.standard.data(forKey: checkInsKey),
              let list = try? decoder.decode([CheckIn].self, from: data) else { return [] }
        return list.sorted(by: { $0.date > $1.date })
    }

    // MARK: Citas
    func save(appointment: AppointmentRequest) {
        var all = loadAppointments()
        if let idx = all.firstIndex(where: { $0.id == appointment.id }) { all[idx] = appointment } else { all.append(appointment) }
        persist(all, key: appointmentsKey)
    }

    func loadAppointments() -> [AppointmentRequest] {
        guard let data = UserDefaults.standard.data(forKey: appointmentsKey),
              let list = try? decoder.decode([AppointmentRequest].self, from: data) else { return [] }
        return list.sorted(by: { $0.createdAt > $1.createdAt })
    }

    private func persist<T: Codable>(_ list: [T], key: String) {
        if let data = try? encoder.encode(list) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
