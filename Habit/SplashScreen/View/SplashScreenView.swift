import SwiftUI

struct SplashScreenView: View {
    @ObservedObject var splashScreenViewModel: SplashScreenViewModel
    
    var body: some View {
        Group {
            switch splashScreenViewModel.uiState {
            case .loading:
                loadingView()

            case .goToSignInScreen:
                splashScreenViewModel.signInView()

            case .goToHomeScreen:
                splashScreenViewModel.homeView()

            case .error(let msg):
                loadingView(error: msg)
            }
        }.onAppear(perform: {
            splashScreenViewModel.onAppear()
        })
    }
}

extension SplashScreenView {
    func loadingView(error: String? = nil) -> some View {
        ZStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
                .padding(20)

            if let error = error {
                Text("").alert(isPresented: .constant(true)) {
                    Alert(title: Text("Habit"), message: Text(error), dismissButton: .default(Text("ok")) {
                        // call to alert
                    }
                )}
            }
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.self) {
            let viewModel = SplashScreenViewModel(interactor: SplashScreenInteractor())
            SplashScreenView(splashScreenViewModel: viewModel)
                .previewDevice("iPhone 14 Pro max")
                .preferredColorScheme($0)
        }
    }
}

