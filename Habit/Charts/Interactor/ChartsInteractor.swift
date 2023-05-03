import Foundation
import Combine

class ChartsInteractor {
    private let chartsRemoteDataSource: ChartsRemoteDataSource = .instance
}

extension ChartsInteractor {
    func fetchHabitValues(habitId: Int) -> Future<[HabitValueResponse], AppError> {
        return chartsRemoteDataSource.fetchHabitValues(habitId: habitId)
    }
}
