import SwiftUI
import Combine

class SignInViewModel: ObservableObject {
    @Published var uiState: SignInUIState = .none
    @Published var email = ""
    @Published var password = ""

    private var cancellable: AnyCancellable?
    private var cancellableSignInRequest: AnyCancellable?

    private let publisher = PassthroughSubject<Bool, Never>()
    private let interactor: SignInInteractor

    init(interactor: SignInInteractor) {
        self.interactor = interactor

        cancellable = publisher.sink { value in
            if value {
                self.uiState = .goToHomeScreen
            }
        }
    }

    deinit {
        cancellable?.cancel()
        cancellableSignInRequest?.cancel()
    }

    func login(email: String, password: String) {
        self.uiState = .loading

        let signInRequest = SignInRequest(email: email, password: password)

        cancellableSignInRequest = interactor.login(loginRequest: signInRequest)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let appError):
                    self.uiState = SignInUIState.error(appError.message)
                    break
                case .finished:
                    break
                }
            } receiveValue: { response in
                let user = UserAuth(
                    accessToken: response.accessToken,
                    refreshToken: response.refreshToken,
                    expires: Date().timeIntervalSince1970 + Double(response.expires),
                    tokenType: response.tokenType
                )

                self.interactor.saveUserOnUserDefaults(userAuth: user)
                self.uiState = .goToHomeScreen
            }
    }
}

extension SignInViewModel {
    func homeView() -> some View {
        return SignInViewRouter.makeHomeView()
    }

    func signUpView() -> some View {
        return SignInViewRouter.makeSignUpView(publisher: publisher)
    }
}
