import Foundation
import Combine

class SignUpRemoteDataSource {
    static let instance: SignUpRemoteDataSource = SignUpRemoteDataSource()

    private init() {}

    func createUser(body: SignUpRequest) -> Future<Bool, AppError> {
        return Future<Bool, AppError> { promise in
            NetworkManager.call(path: .createUser, method: .post, body: body) { result in
                switch result {
                case .failure(let error, let data):
                    if let data = data {
                        if error == .badRequest {
                            let response = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                            let message = response?.detail ?? "Erro interno no servidor"
                            promise(.failure(AppError.response(message: message)))
                        }
                    }
                    break
                case .success(_):
                    promise(.success(true))
                    break
                }
            }
        }
    }
}
