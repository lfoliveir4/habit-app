import Foundation
import SwiftUI

public struct EditTextView: View {
    var placeholder: String = ""
    var error: String? = nil
    var failure: Bool? = nil
    var keyboardType: UIKeyboardType = .default
    var isSecureTextField: Bool = false
    var autoCapitalization: UITextAutocapitalizationType = .none
    @Binding var text: String

    public var body: some View {
        VStack {
            if isSecureTextField {
                SecureField(placeholder, text: $text)
                    .foregroundColor(Color("textColor"))
                    .keyboardType(keyboardType)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                TextField(placeholder, text: $text)
                    .foregroundColor(Color("textColor"))
                    .keyboardType(keyboardType)
                    .autocapitalization(autoCapitalization)
                    .textFieldStyle(CustomTextFieldStyle())
            }

            if let error = error, failure == true, !text.isEmpty {
                Text(error).foregroundColor(.red)
            }
        }.padding(.bottom, 10)
    }
}

struct EditTextView_Previews: PreviewProvider {
    static var previews : some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            VStack {
                EditTextView(
                    placeholder: "email",
                    error: "campo invalido",
                    keyboardType: .emailAddress,
                    text: .constant("Texto")
                ).padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .previewDevice("iPhone 14 Pro Max")
                .preferredColorScheme($0)
        }
    }
}
