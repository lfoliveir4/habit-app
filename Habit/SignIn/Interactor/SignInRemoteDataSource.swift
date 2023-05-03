import Foundation
import Combine

class SignInRemoteDataSource {
    static var instance: SignInRemoteDataSource = SignInRemoteDataSource()

    private init() {}

    func login(request: SignInRequest) -> Future<SignInResponse, AppError> {
        return Future<SignInResponse, AppError> { promise in
            NetworkManager.call(
                path: .login,
                params: [
                    URLQueryItem(name: "username", value: request.email),
                    URLQueryItem(name: "password", value: request.password),
                ]
            ) { result in
                switch result {
                case .failure(let error, let data):
                    if let data = data {
                        if error == .unauthorized {
                            print(String(data: data, encoding: .utf8))
                            let response = try? JSONDecoder().decode(SignInErrorResponse.self, from: data)
                            let message = response?.detail.message ?? "Erro desconhecido no servidor"
                            promise(.failure(AppError.response(message: message)))
                        }
                    }
                    break
                case .success(let data):
                    print(String(data: data, encoding: .utf8))
                    let response = try? JSONDecoder().decode(SignInResponse.self, from: data)

                    guard let response else {
                        print("Error on parse response \(String(data: data, encoding: .utf8))")
                        return
                    }
                    promise(.success(response))
                    break
                }
            }
        }
    }
}
