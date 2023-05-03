import SwiftUI

struct LoadingButtonView: View {
    var action: () -> Void
    var disabled: Bool = false
    var showProgressBar: Bool = false
    var buttonTitle: String

    var body: some View {
        ZStack {
            Button(action: action, label: {
                Text(showProgressBar ? "" : buttonTitle)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .font(Font.system(.title3).bold())
                    .background(
                        disabled ? Color("lightOrange") : Color.orange
                    )
                    .foregroundColor(Color.white)
                    .cornerRadius(4)
            }).disabled(disabled || showProgressBar)

            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .opacity(showProgressBar ? 1 : 0)
        }
    }
}

struct LoadingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            VStack {
                LoadingButtonView(
                    action: { print("oi") },
                    disabled: false,
                    showProgressBar: false,
                    buttonTitle: "Entrar"
                )
            }
            .padding()
            .previewDevice("iPhone 14 Pro Max")
            .preferredColorScheme($0)
        }
    }
}
