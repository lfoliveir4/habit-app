import SwiftUI
import Combine

class SignUpViewModel: ObservableObject {
    @Published var uiState: SignUpUIState = .none

    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var document: String = ""
    @Published var phone: String = ""
    @Published var birthday: String = ""
    @Published var gender = Gender.male

    private var interactor: SignUpInteractor

    var publisher: PassthroughSubject<Bool, Never>!
    private var cancellableSignUp: AnyCancellable?
    private var cancellableSignIn: AnyCancellable?
    
    init(interactor: SignUpInteractor) {
        self.interactor = interactor
    }

    deinit {
        cancellableSignIn?.cancel()
        cancellableSignUp?.cancel()
    }

    func signUp() {
        self.uiState = .loading

        // String: dd/MM/yyy convert to Date
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"

        let dateFormatted = formatter.date(from: birthday)

        // Validate is date correct
        guard let dateFormatted else {
            self.uiState = .error("data inválida \(String(describing: dateFormatted))")
            return
        }

        // Date: yyyy-MM-dd convert to string
        formatter.dateFormat = "yyyy-MM-dd"
        let birthday = formatter.string(from: dateFormatted)

        let signUpRequest = SignUpRequest(
            fullName: fullName,
            email: email,
            password: password,
            document: document,
            phone: phone,
            gender: gender.index,
            birthday: birthday
        )

        cancellableSignUp = interactor.signUp(signUpRequest: signUpRequest)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                    break
                case .finished:
                    break
                }

            } receiveValue: { userCreated in
                if (userCreated) {
                    self.cancellableSignIn = self.interactor.login(
                        loginRequest: SignInRequest(email: self.email, password: self.password)
                    )
                    .receive(on: DispatchQueue.main)
                    .sink { completion in
                        switch completion {
                        case .failure(let appError):
                            self.uiState = .error(appError.message)
                            break

                        case .finished:
                            break
                        }
                    } receiveValue: { successSignIn in
                        self.publisher.send(userCreated)
                        self.uiState = .success
                    }
                }
            }
    }
}


extension SignUpViewModel {
    func homeView() -> some View {
        return SignUpViewRouter.makeHomeView()
    }
}

