import Foundation
import SwiftUI
import Combine

enum SignInViewRouter {
    static func makeHomeView() -> some View {
        return HomeView(viewModel: HomeViewModel())
    }

    static func makeSignUpView(publisher: PassthroughSubject<Bool, Never>) -> some View {
        let viewModel = SignUpViewModel(interactor: SignUpInteractor())
        viewModel.publisher = publisher
        return SignUpView(viewModel: viewModel)
    }
}
