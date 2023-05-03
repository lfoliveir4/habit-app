import SwiftUI

struct HabitView: View {

    @ObservedObject var viewModel: HabitViewModel

    var body: some View {
        ZStack {
            if case HabitUIState.loading = viewModel.uiState {
                loading
            } else {
                NavigationView {
                    ScrollView {
                        VStack(spacing: 12) {
                            if !viewModel.isChartRoute {
                                topContainer

                                addHabitButton
                            }

                            if case HabitUIState.emptyList = viewModel.uiState {
                                Spacer(minLength: 60)

                                VStack {
                                    Image(systemName: "exclamationmark.octagon.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 24, height: 24, alignment: .center)

                                    Text("Nenhum habito Encontrado")
                                }

                            } else if case HabitUIState.fullList(let rows) = viewModel.uiState {

                                LazyVStack {
                                    ForEach(rows) { row in
                                        HabitCardView(
                                            isChartRoute: viewModel.isChartRoute,
                                            viewModel: row
                                        )
                                    }
                                }.padding(.horizontal, 14)

                            } else if case HabitUIState.error(let message) = viewModel.uiState {
                                Text("").alert(isPresented: .constant(true)) {
                                    Alert(
                                        title: Text("Ops! \(message)"),
                                        message: Text("tentar novamente"),
                                        primaryButton: .default(Text("Sim")) {
                                            // retentativa
                                            viewModel.onAppear()
                                        },
                                        secondaryButton: .cancel()
                                    )
                                }

                            }
                        }.navigationBarTitle("Meus Habitos")
                    }
                }
            }
        }.onAppear {
            if !viewModel.opened {
                viewModel.onAppear()
            }
        }
    }
}

extension HabitView {
    var loading: some View {
        ProgressView()
    }
}

extension HabitView {
    var topContainer: some View {
        VStack(alignment: .center, spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50, alignment: .center)

            Text(viewModel.title)
                .font(.system(.title).bold())
                .foregroundColor(Color.orange)

            Text(viewModel.headeline)
                .font(.system(.title3).bold())
                .foregroundColor(Color("textColor"))

            Text(viewModel.description)
                .font(.system(.subheadline))
                .foregroundColor(Color("textColor"))

        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray, lineWidth: 1)
        )
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

extension HabitView {
    var addHabitButton: some View {
        NavigationLink(destination: viewModel.createHabitView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        ) {
            Label("Criar Habito", systemImage: "plus.app")
                .modifier(ButtonStyle())
        }.padding(.horizontal, 16)
    }
}

struct HabitView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            HomeViewRouter.makeHabitView(
                viewModel: HabitViewModel(
                    isChartRoute: false,
                    interactor: HabitInteractor()
                )
            )
                .previewDevice("iPhone 14 Pro Max")
                .preferredColorScheme($0)
        }
    }
}
