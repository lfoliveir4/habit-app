import Foundation
import Combine
import SwiftUI

class CreateHabitViewModel: ObservableObject {
    @Published var uiState: HabitDetailUIState = .none
    @Published var name = ""
    @Published var label = ""

    @Published var image: Image? = Image(systemName: "camera.fill")
    @Published var imageData: Data? = nil

    let interactor: CreateHabitInteractor
    var cancellable: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    var habitPublisher: PassthroughSubject<Bool, Never>?

    init(interactor: CreateHabitInteractor) {
        self.interactor = interactor
    }

    deinit {
        cancellable?.cancel()

        for cancellable in cancellables {
            cancellable.cancel()
        }
    }

    func save() {
        self.uiState = .loading

        let habitCreateRequest = CreateHabitRequest(
            imageData: imageData,
            name: name,
            label: label
        )

        cancellable = interactor
            .save(habitCreateRequest: habitCreateRequest)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch (completion) {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                    print("Error: \(appError)")
                    break
                case .finished:
                    break
                }
            }, receiveValue: {
                self.uiState = .success
                self.habitPublisher?.send(true)
            })
    }
}
