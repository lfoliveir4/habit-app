import Foundation
import Combine

class ProfileInteractor {
    private let profileRemoteDataSource: ProfileRemoteDataSource = .instance
}

extension ProfileInteractor {
    func fetchProfile() -> Future<ProfileResponse, AppError> {
        return profileRemoteDataSource.fetchUser()
    }

    func updateUser(userId: Int, body: ProfileRequest) -> Future<ProfileResponse, AppError> {
        return profileRemoteDataSource.updateUser(userId: userId, body: body)
    }
}
