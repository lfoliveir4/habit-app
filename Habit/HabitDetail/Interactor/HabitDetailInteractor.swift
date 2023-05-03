import Foundation
import Combine

class HabitDetailInteractor {
    private let habitDetailRemoteDataSource: HabitDetailRemoteDataSource = .instance
}

extension HabitDetailInteractor {
    func save(habitId: Int, body: HabitValueRequest) -> Future<Bool, AppError> {
        habitDetailRemoteDataSource.save(habitId: habitId, body: body)
    }
}
