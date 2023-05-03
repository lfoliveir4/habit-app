import Foundation

struct UserAuth: Codable {
    var accessToken: String
    var refreshToken: String
    var expires: Double = 0.0
    var tokenType: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expires
        case tokenType = "token_type"
    }
}
