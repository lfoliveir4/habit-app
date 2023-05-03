import Foundation

enum ProfileUIState: Equatable {
    case none
    case loading
    case success
    case error(String)

    
    case updateProfileloading
    case updateProfilesuccess
    case updateProfileerror(String)
}
