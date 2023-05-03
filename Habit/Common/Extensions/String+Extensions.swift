import Foundation

extension String {
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }

    func toDate(
        sourcePattern source: String,
        destinationPatterns destination: String
    ) -> String? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = source

        let dateFormatted = formatter.date(from: self)

        // Validate is date correct
        guard let dateFormatted else { return nil }

        // Date: yyyy-MM-dd convert to string
        formatter.dateFormat = destination
        return formatter.string(from: dateFormatted)
    }

    func toDate(sourcePattern source: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = source

        return formatter.date(from: self)
    }
}
