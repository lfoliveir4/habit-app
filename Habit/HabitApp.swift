import SwiftUI

@main
struct HabitApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = SplashScreenViewModel(interactor: SplashScreenInteractor())
            SplashScreenView(splashScreenViewModel: viewModel)
        }
    }
}
