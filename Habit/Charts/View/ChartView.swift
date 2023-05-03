import SwiftUI
import Charts

struct ChartView: View {
    @ObservedObject var viewModel: ChartsViewModel

    var body: some View {
        ZStack {
          if case ChartsUIState.loading = viewModel.uiState {
            ProgressView()
          } else {
            VStack {
              if case ChartsUIState.emptyChart = viewModel.uiState {
                Image(systemName: "exclamationmark.octagon.fill")
                  .resizable()
                  .scaledToFit()
                  .frame(width: 24, height: 24, alignment: .center)

                Text("Nenhum hábito encontrado :(")
              } else if case ChartsUIState.error(let msg) = viewModel.uiState {
                Text("")
                  .alert(isPresented: .constant(true)) {
                    Alert(
                      title: Text("Ops! \(msg)"),
                      message: Text("Tentar novamente?"),
                      primaryButton: .default(Text("Sim")) {
                        viewModel.onAppear()
                      },
                      secondaryButton: .cancel()
                    )
                  }
              } else {
                BoxChartView(entries: $viewModel.entries, dates: $viewModel.dates)
                  .frame(maxWidth: .infinity, maxHeight: 350)
              }
            }
          }
        }
        .onAppear(perform: viewModel.onAppear)
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(viewModel: ChartsViewModel(habitId: 1, interactor: ChartsInteractor()))
    }
}
