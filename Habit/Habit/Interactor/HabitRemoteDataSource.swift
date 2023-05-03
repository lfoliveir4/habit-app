import Foundation
import Combine

class HabitRemoteDataSource {
    static var instance: HabitRemoteDataSource = HabitRemoteDataSource()

    private init() {}

    func fetchHabits() -> Future<[HabitResponse], AppError> {
        return Future<[HabitResponse], AppError> { promise in
            NetworkManager.call(
                path: .habits,
                method: .get
            ) { result in
                switch result {
                case .failure(_, let data):
                    if let data = data {
                        let response = try? JSONDecoder().decode(SignInErrorResponse.self, from: data)
                        let message = response?.detail.message ?? "Erro desconhecido no servidor"
                        promise(.failure(AppError.response(message: message)))
                    }
                    break
                case .success(let data):
                    let response = try? JSONDecoder().decode([HabitResponse].self, from: data)

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
