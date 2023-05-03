import Foundation

struct SignUpResponse: Decodable {
    let detail: String?

    enum CodingKeys: String, CodingKey {
        case detail
    }
}
