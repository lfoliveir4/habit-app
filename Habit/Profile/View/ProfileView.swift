import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var disabledDone: Bool {
        viewModel.fullNameValidation.failure || viewModel.phoneValidation.failure
    }

    var body: some View {
        ZStack {
            if case ProfileUIState.loading = viewModel.uiState {
                ProgressView()
            } else {
                NavigationView {
                    VStack {
                        Form {
                            Section(header: Text("Dados Cadastrais")) {
                                HStack {
                                    Text("Nome")
                                    Spacer()
                                    TextField(
                                        "Digite o nome",
                                        text: $viewModel.fullNameValidation.value
                                    )
                                        .multilineTextAlignment(.trailing)
                                        .keyboardType(.alphabet)
                                }

                                if viewModel.fullNameValidation.failure {
                                    Text("O nome deve ter mais que 3 caracteres").foregroundColor(.red)
                                }

                                HStack {
                                    Text("E-mail")
                                    Spacer()
                                    TextField("", text: $viewModel.email)
                                        .disabled(true)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(Color.gray)
                                }

                                HStack {
                                    Text("CPF")
                                    Spacer()
                                    TextField("", text: $viewModel.document)
                                        .disabled(true)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(Color.gray)
                                }

                                HStack {
                                    Text("Digite o seu celular")
                                    Spacer()
                                    TextField("", text: $viewModel.phoneValidation.value)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(Color.gray)
                                        .keyboardType(.numberPad)
                                }

                                if viewModel.phoneValidation.failure {
                                    Text("Entre com o DDD + 8 ou 9 digitos").foregroundColor(.red)
                                }

                                HStack {
                                    Text("Data de nascimento")
                                    Spacer()
                                    TextField("", text: $viewModel.birthday)
                                        .disabled(true)
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(Color.gray)
                                }

                                NavigationLink(
                                    destination: GenderSelectorView(
                                        title: "Escolha o Genero",
                                        genders: Gender.allCases,
                                        selectedGender: $viewModel.gender
                                    ),
                                    label: {
                                        Text("Genero")
                                        Spacer()
                                    }
                                )
                            }
                        }
                    }
                    .navigationTitle("Editar Perfil")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if ProfileUIState.updateProfileloading == viewModel.uiState {
                                ProgressView()
                            } else {
                                Button("Salvar", action: {
                                    viewModel.updateProfile()
                                }).opacity(disabledDone ? 0 : 1)
                            }
                        }
                    }
                }

            }

            if case ProfileUIState.error(let value) = viewModel.uiState {
                Text("").alert(isPresented: .constant(true)) {
                    Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("ok")) {
                        // call to alert
                    }
                )}
            }

        }.onAppear {
            viewModel.fetchProfile()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            viewModel: ProfileViewModel(interactor: ProfileInteractor())
        )
    }
}
