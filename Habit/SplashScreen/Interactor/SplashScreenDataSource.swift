import Foundation
import Combine

class SplashScreenDataSource {
    static let instance: SplashScreenDataSource = SplashScreenDataSource()

    private init() {}

    func refreshToken(request: SplashScreenRefreshRequest) -> Future<SignInResponse, AppError> {
        return Future<SignInResponse, AppError> { promise in
            NetworkManager.call(
                path: .refreshToken,
                method: .put,
                body: request
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
