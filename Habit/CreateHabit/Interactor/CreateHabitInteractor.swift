import Foundation
import Combine

class CreateHabitInteractor {
    private let createHabitRemoteDataSource: CreateHabitRemoteDataSource = .instance
}

extension CreateHabitInteractor {
    func save(habitCreateRequest body: CreateHabitRequest) -> Future<Void, AppError> {
        return createHabitRemoteDataSource.save(body: body)
    }
}
