import Foundation
import Combine

class SignUpInteractor {
    private let signUpRemoteDataSource: SignUpRemoteDataSource = .instance
    private let signInRemoteDataSource: SignInRemoteDataSource = .instance
}

extension SignUpInteractor {
    func signUp(signUpRequest request: SignUpRequest) -> Future<Bool, AppError> {
        return signUpRemoteDataSource.createUser(body: request)
    }

    func login(loginRequest request: SignInRequest) -> Future<SignInResponse, AppError> {
        return signInRemoteDataSource.login(request: request)
    }
}
