import Foundation
import SwiftUI
import Combine

enum SignUpViewRouter {
    static func makeHomeView() -> some View {
        let viewModel = HomeViewModel()
        return HomeView(viewModel: HomeViewModel())
    }
}
