import Foundation

enum SignUpUIState: Equatable {
    case none
    case loading
    case success
    case error(String)
}
