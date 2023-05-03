import Foundation
import Combine

class SignInInteractor {
    private let signInremoteDataSource: SignInRemoteDataSource = .instance
    private let localDataSource: LocalDataSource = .instance
}

extension SignInInteractor {
    func login(loginRequest request: SignInRequest) -> Future<SignInResponse, AppError> {
        return signInremoteDataSource.login(request: request)
    }

    func saveUserOnUserDefaults(userAuth: UserAuth) {
        return localDataSource.saveUserOnUserDefaults(userAuth: userAuth)
    }
}
