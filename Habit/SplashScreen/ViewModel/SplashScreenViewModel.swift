import SwiftUI
import Combine

class SplashScreenViewModel: ObservableObject {
    @Published var uiState: SplashScreenUIState = .loading

    private var splashScreenCancelableAuthentication: AnyCancellable?
    private var splashScreenCancelableRefreshToken: AnyCancellable?
    private var interactor: SplashScreenInteractor

    init(interactor: SplashScreenInteractor) {
        self.interactor = interactor
    }

    deinit {
        splashScreenCancelableAuthentication?.cancel()
        splashScreenCancelableRefreshToken?.cancel()
    }

    func onAppear() {
        splashScreenCancelableAuthentication = interactor.getUserOnUserDefaults()
            .receive(on: DispatchQueue.main)
            .sink { user in
                if user == nil {
                    self.uiState = .goToSignInScreen
                } else if (Date().timeIntervalSince1970 > Double(user!.expires)) {
                    let refreshRequest = SplashScreenRefreshRequest(token: user?.refreshToken)

                    self.splashScreenCancelableRefreshToken = self.interactor.refreshToken(refreshRequest: refreshRequest)
                        .receive(on: DispatchQueue.main)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(_):
                                self.uiState = .goToSignInScreen
                                break
                            case .finished:
                                break
                            }
                        }, receiveValue: { response in
                            let user = UserAuth(
                                accessToken: response.accessToken,
                                refreshToken: response.refreshToken,
                                expires: Date().timeIntervalSince1970 + Double(response.expires),
                                tokenType: response.tokenType
                            )

                            self.interactor.saveUserOnUserDefaults(userAuth: user)
                            self.uiState = .goToHomeScreen
                        })
                } else {
                    self.uiState = .goToHomeScreen
                }
            }
    }
}

extension SplashScreenViewModel {
    func signInView() -> some View {
        return SplashScreenRouter.makeSignInView()
    }

    func homeView() -> some View {
        return SplashScreenRouter.makeHomeView()

    }
}
