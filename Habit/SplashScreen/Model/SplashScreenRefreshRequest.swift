import Foundation

struct SplashScreenRefreshRequest: Encodable {
    let token: String?

    enum CodingKeys: String, CodingKey {
        case token = "refresh_token"
    }
}
