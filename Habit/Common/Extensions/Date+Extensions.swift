import Foundation

extension Date {
    func toString(destinationPattern destination: String) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = destination

        return formatter.string(from: self)
    }
}
