import Foundation
import Combine
import SwiftUI

enum HabitViewRouter {
    static func makeCreateHabitView(
        habitPublisher: PassthroughSubject<Bool, Never>
    ) -> some View {
        let viewModel = CreateHabitViewModel(interactor: CreateHabitInteractor())
        viewModel.habitPublisher = habitPublisher
        return CreateHabitView(viewModel: viewModel)
    }
}
