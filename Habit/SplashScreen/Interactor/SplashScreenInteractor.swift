import Foundation
import Combine

class SplashScreenInteractor {
    private let localDataSource: LocalDataSource = .instance
    private let splashScreenDataSource: SplashScreenDataSource = .instance
}

extension SplashScreenInteractor {
    func getUserOnUserDefaults() -> Future<UserAuth?, Never> {
        return localDataSource.getUserOnUserDefaults()
    }

    func saveUserOnUserDefaults(userAuth: UserAuth)  {
        return localDataSource.saveUserOnUserDefaults(userAuth: userAuth)
    }

    func refreshToken(
        refreshRequest request: SplashScreenRefreshRequest
    ) -> Future<SignInResponse, AppError> {
        return splashScreenDataSource.refreshToken(request: request)
    }
}

