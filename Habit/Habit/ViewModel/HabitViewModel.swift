import Foundation
import Combine
import SwiftUI

class HabitViewModel: ObservableObject {
    @Published var uiState: HabitUIState = .loading
    @Published var title = ""
    @Published var headeline = ""
    @Published var description = ""
    @Published var opened = false

    private var cancelableHabitRequest: AnyCancellable?
    private var cancelableNotify: AnyCancellable?

    private let interactor: HabitInteractor
    private let habitPublisher = PassthroughSubject<Bool, Never>()
    let isChartRoute: Bool

    init(isChartRoute: Bool, interactor: HabitInteractor) {
        self.isChartRoute = isChartRoute
        self.interactor = interactor

        cancelableNotify = habitPublisher.sink(receiveValue: { saved in
            self.onAppear()
        })
    }

    deinit {
        cancelableHabitRequest?.cancel()
    }

    func onAppear() {
        self.opened = true
        self.uiState = .loading

        cancelableHabitRequest = interactor.fetchHabits()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                case .finished:
                    break
                }

            }, receiveValue: { response in
                if response.isEmpty {
                    self.uiState = .emptyList
                    self.title = ""
                    self.headeline = "Fique ligado!"
                    self.description = "Você ainda não possui habitos"
                } else {
                    self.uiState = .fullList(
                        response.map {
                            let lastDate = $0.lastDate?.toDate(
                                sourcePattern: "yyyy-MM-dd'T'HH:mm:ss",
                                destinationPatterns: "dd/MM/yyyy HH:mm"
                            ) ?? ""

                            var state = Color.green
                            self.title = "Muito Bom"
                            self.headeline = "Seus Habitos estão em dia"
                            self.description = ""

                            let dateToCompare = $0.lastDate?.toDate(
                                sourcePattern: "yyyy-MM-dd'T'HH:mm:ss"
                            ) ?? Date()

                            if dateToCompare < Date()  {
                                state = .red
                                self.title = "Atenção"
                                self.headeline = "Fique ligado!"
                                self.description = "Você está atrasado nos hábitos"
                            }

                            return HabitCardViewModel(
                                id: $0.id,
                                icon: $0.iconURL ?? "",
                                date: lastDate,
                                name: $0.name,
                                label: $0.label,
                                value: "\($0.value ?? 0)",
                                state: state,
                                habitPublisher: self.habitPublisher
                            )
                        }
                    )
                }
            })
    }
}

extension HabitViewModel {
    func createHabitView() -> some View {
        return HabitViewRouter.makeCreateHabitView(habitPublisher: habitPublisher)
    }
}
