import SwiftUI

struct CreateHabitView: View {
    @ObservedObject var viewModel: CreateHabitViewModel

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var shouldOpenCamera: Bool = false

    init(viewModel: CreateHabitViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 12) {

                Button(
                    action: {
                        self.shouldOpenCamera = true
                    },
                    label: {
                        VStack {
                            viewModel.image!
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(Color.orange)

                            Text("Clique aqui para enviar")
                                .foregroundColor(Color.orange)
                        }
                    }
                )
                .padding(.bottom, 12)
                .sheet(isPresented: self.$shouldOpenCamera) {
                    ImagePickerView(
                        isPresented: $shouldOpenCamera,
                        image: self.$viewModel.image,
                        imageData: self.$viewModel.imageData
                    )

                }
            }

            VStack {
                TextField("Escreva aqui o nome do habito", text: $viewModel.name)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(PlainTextFieldStyle())

                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
            }.padding(.horizontal, 32)

            VStack {
                TextField("Escreva aqui a unidade de medida", text: $viewModel.label)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(PlainTextFieldStyle())

                Divider()
                    .frame(height: 1)
                    .background(Color.gray)
            }.padding(.horizontal, 32)


            LoadingButtonView(
                action: { viewModel.save() },
                disabled: self.viewModel.name.isEmpty || self.viewModel.label.isEmpty,
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

struct CreateHabitView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            CreateHabitView(viewModel: CreateHabitViewModel(interactor: CreateHabitInteractor()))
                .previewDevice("iPhone 14 Pro Max")
                .preferredColorScheme($0)
        }
    }
}
