import Foundation
import Combine

class ChartsRemoteDataSource {
    static let instance: ChartsRemoteDataSource = ChartsRemoteDataSource()

    private init() {}

    func fetchHabitValues(habitId: Int) -> Future<[HabitValueResponse], AppError> {
        return Future<[HabitValueResponse], AppError> { promise in
            let path = String(
                format: NetworkManager.Endpoint.habitValues.rawValue,
                habitId
            )

            NetworkManager.call(path: path, method: .get) { result in
                switch result {
                case .failure(_, let data):
                    if let data {
                        let response = try? JSONDecoder().decode(SignInErrorResponse.self, from: data)
                        let message = response?.detail.message ?? "Erro desconhecido no servidor"
                        promise(.failure(AppError.response(message: message)))
                    }
                    break
                case .success(let data):
                    let response = try? JSONDecoder().decode([HabitValueResponse].self, from: data)

                    guard let response else {
                        print("log error: \(data)")
                        return
                    }

                    promise(.success(response))
                    break
                }
            }
        }
    }
}
