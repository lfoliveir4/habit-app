import Foundation
import Charts
import Combine

class ChartsViewModel: ObservableObject {
    @Published var uiState = ChartsUIState.loading
    @Published var entries: [ChartDataEntry] = []
    @Published var dates: [String] = []

    private let habitId: Int
    private let interactor: ChartsInteractor
    private var cancellable: AnyCancellable?

    init(habitId: Int, interactor: ChartsInteractor) {
        self.habitId = habitId
        self.interactor = interactor
    }

    deinit {
        cancellable?.cancel()
    }

    func onAppear() {
        cancellable = interactor.fetchHabitValues(habitId: habitId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch(completion) {
                case .failure(let appError):
                    self.uiState = .error(appError.message)
                case .finished:
                    break
                }
            }, receiveValue: { response in
                if response.isEmpty {
                    self.uiState = .emptyChart
                } else {
                    self.dates = response.map { $0.createdDate }

                    self.entries = zip(response.startIndex..<response.endIndex, response).map { index, res in
                        ChartDataEntry(x: Double(index), y: Double((res.value)))
                    }

                    self.uiState = .success
                }
            })
    }
}
