import SwiftUI
import Combine

struct HabitDetailView: View {
    @ObservedObject var viewModel: HabitDetailViewModel

    init(viewModel: HabitDetailViewModel) {
        self.viewModel = viewModel
    }

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12) {
                Text(viewModel.name)
                    .foregroundColor(Color.orange)
                    .font(.title.bold())

                Text("Unidade: \(viewModel.label)\n")
            }

            VStack {
                TextField("Escreva aqui o valor conquistado", text: $viewModel.value)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(PlainTextFieldStyle())
                    .keyboardType(.numberPad)

                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
            }.padding(.horizontal, 32)

            Text("Os registros devem ser feitos em até 24 horas.\nHabitos se constroem todos os dias 😉")

            LoadingButtonView(
                action: { viewModel.save() },
                disabled: self.viewModel.value.isEmpty,
                showProgressBar: self.viewModel.uiState == .loading,
                buttonTitle: "Salvar"
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Button("Cancelar") {
                self.presentationMode.wrappedValue.dismiss()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)

            Spacer()
        }
        .padding(.horizontal, 8)
    }
}

struct HabitDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            HabitDetailView(viewModel: HabitDetailViewModel(
                id: 1,
                name: "Estudar Ingles",
                label: "horas",
                interactor: HabitDetailInteractor()
            ))
                .previewDevice("iPhone SE (3rd generation)")
                .preferredColorScheme($0)
        }
    }
}
