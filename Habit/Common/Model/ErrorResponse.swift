import Foundation

struct ErrorResponse: Decodable {
    let detail: String

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
