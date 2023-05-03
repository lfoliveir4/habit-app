import Foundation
import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    
    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Cadastro")
                            .foregroundColor(Color("textColor"))
                            .font(Font.system(.title).bold())
                            .padding(.bottom, 8)
                        fullNameField
                        emailField
                        passwordField
                        documentField
                        phoneField
                        birthdayField
                        genderField
                        signUpButton
                    }
                    Spacer()
                }.padding(.horizontal, 8)
            }.padding()
        }

        if case SignUpUIState.error(let value) = viewModel.uiState {
            Text("").alert(isPresented: .constant(true)) {
                Alert(title: Text("Habit"), message: Text(value), dismissButton: .default(Text("ok")) {
                    // call to alert
                }
            )}
        }
    }
}

extension SignUpView {
    var fullNameField: some View {
        EditTextView(
            placeholder: "Nome completo",
            failure: viewModel.fullName.count < 3,
            keyboardType: .alphabet,
            isSecureTextField: false,
            text: $viewModel.fullName
        )
    }
}

extension SignUpView {
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

extension SignUpView {
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

extension SignUpView {
    var documentField: some View {
        EditTextView(
            placeholder: "CPF",
            error: "CPF inválido",
            failure: viewModel.document.count != 11,
            keyboardType: .numberPad,
            isSecureTextField: false,
            text: $viewModel.document
        )
    }
}

extension SignUpView {
    var phoneField: some View {
        EditTextView(
            placeholder: "Celular",
            error: "DDD + ",
            failure: viewModel.phone.count < 10 || viewModel.phone.count >= 12,
            keyboardType: .numberPad,
            isSecureTextField: false,
            text: $viewModel.phone
        )
    }
}

extension SignUpView {
    var birthdayField: some View {
        EditTextView(
            placeholder: "Data de nascimento",
            error: "verifique se sua data esta no formato dd/MM/yyyy",
            failure: viewModel.birthday.count != 10,
            keyboardType: .default,
            isSecureTextField: false,
            text: $viewModel.birthday
        )
    }
}

extension SignUpView {
    var genderField: some View {
        Picker("Gender", selection: $viewModel.gender) {
            ForEach(Gender.allCases, id: \.self) { value in
                Text(value.rawValue)
                    .tag(value)
            }
        }.pickerStyle(SegmentedPickerStyle())
            .padding(.top, 16)
            .padding(.bottom, 32)
    }
}

extension SignUpView {
    var signUpButton: some View {
        LoadingButtonView(
            action: {
                viewModel.signUp()
            },
            disabled:
                !viewModel.email.isEmail() ||
            viewModel.fullName.count < 3 ||
            viewModel.password.count < 8 ||
            viewModel.document.count != 11 ||
            viewModel.phone.count < 10 || viewModel.phone.count >= 12 ||
            viewModel.birthday.count != 10,
            showProgressBar: self.viewModel.uiState == SignUpUIState.loading,
            buttonTitle: "Realize seu cadastro"
        )
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            SignUpView(viewModel: SignUpViewModel(interactor: SignUpInteractor()))
                .previewDevice("iPhone 14 Pro Max")
                .preferredColorScheme($0)
        }
    }
}
