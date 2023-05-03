import Foundation
import Combine

class ProfileRemoteDataSource {
    static var instance: ProfileRemoteDataSource = ProfileRemoteDataSource()

    private init() {}

    func fetchUser() -> Future<ProfileResponse, AppError> {
        return Future<ProfileResponse, AppError> { promise in
            NetworkManager.call(path: .fetchUser, method: .get) { result in
                switch result {
                case .failure(_, let data):
                    if let data {
                        let response = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                        let message = response?.detail ?? "Erro desconhecido no servidor"
                        promise(.failure(AppError.response(message: message)))
                    }
                    break

                case .success(let data):
                    let response = try? JSONDecoder().decode(ProfileResponse.self, from: data)

                    guard let response else {
                        print("Error on parse response \(String(describing: String(data: data, encoding: .utf8)))")
                        return
                    }
                    promise(.success(response))
                }
            }
        }
    }

    func updateUser(userId: Int, body: ProfileRequest) -> Future<ProfileResponse, AppError> {
        return Future<ProfileResponse, AppError> { promise in
            let path = String(format: NetworkManager.Endpoint.updateUser.rawValue, userId)
            
            NetworkManager.call(
                path: path,
                method: .put,
                body: body
            ) { result in
                switch result {
                case .failure(_, let data):
                    if let data {
                        let response = try? JSONDecoder().decode(ErrorResponse.self, from: data)
                        let message = response?.detail ?? "Erro desconhecido no servidor"
                        promise(.failure(AppError.response(message: message)))
                    }
                    break

                case .success(let data):
                    let response = try? JSONDecoder().decode(ProfileResponse.self, from: data)

                    guard let response else {
                        print("Error on parse response \(String(describing: String(data: data, encoding: .utf8)))")
                        return
                    }
                    promise(.success(response))
                }
            }
        }
    }
}
