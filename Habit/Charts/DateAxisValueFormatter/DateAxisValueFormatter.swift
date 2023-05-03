import Foundation
import Charts

class DateAxisValueFormatter: IndexAxisValueFormatter {
    let dates: [String]

    init(dates: [String]) {
        self.dates = dates
        super.init()
    }

    override func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let position = Int(value)
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        if position > 0 && position < dates.count {
            let date = dateFormatter.date(from: dates[position])

            guard let date else { return "" }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM"

            let createdAt = dateFormatter.string(from: date)

            return createdAt
        } else {
            return ""
        }
    }
}
