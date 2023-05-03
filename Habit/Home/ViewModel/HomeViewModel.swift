import Foundation
import SwiftUI

class HomeViewModel: ObservableObject {
    let habitViewModel = HabitViewModel(isChartRoute: false, interactor: HabitInteractor())
    let habitForChartsViewModel = HabitViewModel(isChartRoute: true, interactor: HabitInteractor())
    let profileViewModel = ProfileViewModel(interactor: ProfileInteractor())
}

extension HomeViewModel {
    func habitView() -> some View {
        return HomeViewRouter.makeHabitView(viewModel: habitViewModel)
    }

    func profileView() -> some View {
        return HomeViewRouter.makeProfileView(viewModel: profileViewModel)
    }

    func habitForChartView() -> some View {
        return HomeViewRouter.makeHabitView(viewModel: habitForChartsViewModel)
    }
}
