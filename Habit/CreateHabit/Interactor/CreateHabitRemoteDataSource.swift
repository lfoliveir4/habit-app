import Foundation
import Combine

class CreateHabitRemoteDataSource {
    static let instance: CreateHabitRemoteDataSource = CreateHabitRemoteDataSource()

    private init() {}

    func save(body: CreateHabitRequest) -> Future<Void, AppError> {
        return Future<Void, AppError> { promise in
            NetworkManager.call(
                path: .habits,
                params: [
                    URLQueryItem(name: "name", value: body.name),
                    URLQueryItem(name: "label", value: body.label)
                ],
                data: body.imageData
            ) { result in
                switch result {
                case .failure(_, let data):
                    if let data {
                        let response = try? JSONDecoder().decode(SignInErrorResponse.self, from: data)
                        let message = response?.detail.message ?? "Erro desconhecido no servidor"
                        print("error: \(response?.detail)")
                        promise(.failure(AppError.response(message: message)))
                    }
                    break
                case .success(_):
                    promise(.success( () ))
                    break
                }
            }
        }
    }
}
