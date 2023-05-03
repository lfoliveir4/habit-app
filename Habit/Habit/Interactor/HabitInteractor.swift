import Foundation
import Combine

class HabitInteractor {
    private let habitRemoteDataSource: HabitRemoteDataSource = .instance
}

extension HabitInteractor {
    func fetchHabits() -> Future<[HabitResponse], AppError> {
        return habitRemoteDataSource.fetchHabits()
    }
}
