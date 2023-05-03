import Foundation
import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel: SignInViewModel
    
    @State var action: Int? = 0
    @State var navigationBarHidden = true

    var body: some View {
        ZStack {
            if case SignInUIState.goToHomeScreen = viewModel.uiState {
                viewModel.homeView()
            } else {
                NavigationView {
                    ScrollView {
                        VStack(alignment: .center) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .padding(.horizontal, 16)

                            emailField

                            passwordField

                            signInButton

                            registerLink
                        }

                        if case SignInUIState.error(let value) = viewModel.uiState {
                            Text("").alert(isPresented: .constant(true)) {
                                Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("ok")) {
                                    // call to alert
                                }
                            )}
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 32)
                    .navigationTitle("Login")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarHidden(navigationBarHidden)
                }
            }
        }
    }
}

extension SignInView {
    var emailField: some View {
        EditTextView(
            placeholder: "E-mail",
            error: "Email invalido",
            failure: !viewModel.email.isEmail(),
            keyboardType: .emailAddress,
            text: $viewModel.email
        )
    }
}

extension SignInView {
    var passwordField: some View {
        EditTextView(
            placeholder: "Senha",
            error: "Senha deve ter ao menos 8 caracteres",
            failure: viewModel.password.count < 8,
            isSecureTextField: true,
            text: $viewModel.password
        )
    }
}

extension SignInView {
    var signInButton: some View {
        LoadingButtonView(
            action: {
                viewModel.login(email: viewModel.email, password: viewModel.password)
            },
            disabled: !viewModel.email.isEmail() || viewModel.password.count < 8,
            showProgressBar: self.viewModel.uiState == SignInUIState.loading,
            buttonTitle: "Entrar"
        )
    }
}

extension SignInView {
    var registerLink: some View {
        VStack {
            Text("Ainda não possui um login ativo?")
                .foregroundColor(.gray)
                .padding(.top, 48)

            ZStack {
                NavigationLink(
                    destination: viewModel.signUpView(),
                    tag: 1,
                    selection: $action,
                    label: { EmptyView() })

                Button("Realize seu cadastro") {
                    self.action = 1
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            SignInView(viewModel: SignInViewModel(interactor: SignInInteractor()))
                .previewDevice("iPhone 14 Pro Max")
                .preferredColorScheme($0)
        }
    }
}
