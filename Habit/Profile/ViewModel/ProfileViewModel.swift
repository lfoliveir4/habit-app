import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var fullNameValidation = FullNameValidation()
    @Published var phoneValidation = PhoneValidator()
    @Published var uiState: ProfileUIState = .none

    var userId: Int?
    @Published var email = ""
    @Published var document = ""
    @Published var gender: Gender?
    @Published var birthday = ""

    private var cancellableFetchProfile: AnyCancellable?
    private var cancellableUpdateProfile: AnyCancellable?

    private let interactor: ProfileInteractor

    init(interactor: ProfileInteractor) {
        self.interactor = interactor
    }

    deinit {
        cancellableFetchProfile?.cancel()
        cancellableUpdateProfile?.cancel()
    }

    func fetchProfile() {
        self.uiState = .loading

        cancellableFetchProfile = interactor.fetchProfile()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                self.userId = response.id
                self.email = response.email
                self.document = response.document
                self.gender = Gender.allCases[response.gender]
                self.fullNameValidation.value = response.fullName
                self.phoneValidation.value = response.phone

                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"

                let dateFormatted = formatter.date(from: response.birthday)

                guard let dateFormatted else {
                    self.uiState = .error("data Invalida \(response.birthday)")
                    return
                }

                formatter.dateFormat = "dd/MM/yyyy"
                let birthday = formatter.string(from: dateFormatted)
                self.birthday = birthday
                self.uiState = .success
            })
    }

    func updateProfile() {
        self.uiState = .updateProfileloading

        guard let userId, let gender else { return }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/yyyy"

        let dateFormatted = formatter.date(from: self.birthday)

        guard let dateFormatted else {
            self.uiState = .updateProfileerror("Data Invalida \(String(describing: dateFormatted))")
            return
        }

        formatter.dateFormat = "yyyy-MM-dd"
        let birthday = formatter.string(from: dateFormatted)


        let profileRequest = ProfileRequest(
            id: userId,
            fullName: fullNameValidation.value,
            phone: phoneValidation.value,
            gender: gender.index,
            birthday: birthday
        )

        cancellableUpdateProfile = interactor.updateUser(
            userId: userId,
            body: profileRequest
        )
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { completion in
            switch completion {
            case .failure(let appError):
                self.uiState = .updateProfileerror(appError.message)
            case .finished:
                break
            }
        }, receiveValue: { response in
            self.uiState = .updateProfilesuccess
        })
    }
}

class FullNameValidation: ObservableObject {
    @Published var failure = false

    var value: String = "" {
        didSet {
            failure = value.count < 3
        }
    }
}

class PhoneValidator: ObservableObject {
    @Published var failure = false

    var value: String = "" {
        didSet {
            failure = value.count < 10 || value.count >= 12
        }
    }
}
