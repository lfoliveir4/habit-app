import Foundation
import Combine

class HabitDetailRemoteDataSource {
    static let instance: HabitDetailRemoteDataSource = HabitDetailRemoteDataSource()

    private init() {}

    func save(habitId: Int, body: HabitValueRequest) -> Future<Bool, AppError> {
        return Future<Bool, AppError> { promise in
            let path = String(
                format: NetworkManager.Endpoint.habitValues.rawValue,
                habitId
            )

            NetworkManager.call(path: path, method: .post, body: body) { result in
                switch result {
                case .failure(_, let data):
                    if let data {
                        let response = try? JSONDecoder().decode(SignInErrorResponse.self, from: data)
                        let message = response?.detail.message ?? "Erro desconhecido no servidor"
                        promise(.failure(AppError.response(message: message)))
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
