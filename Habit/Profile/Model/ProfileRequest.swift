import Foundation

struct ProfileRequest: Encodable {
    let id: Int
    let fullName: String
    let phone: String
    let gender: Int
    let birthday: String

    enum CodingKeys: String, CodingKey {
        case id
        case fullName = "name"
        case phone
        case gender
        case birthday
    }
}
