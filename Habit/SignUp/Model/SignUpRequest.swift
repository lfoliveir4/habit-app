import Foundation

struct SignUpRequest: Encodable {
    let fullName: String
    let email: String
    let password: String
    let document: String
    let phone: String
    let gender: Int
    let birthday: String

    enum CodingKeys: String, CodingKey {
        case fullName = "name"
        case email
        case password
        case document
        case phone
        case gender
        case birthday
    }
}
