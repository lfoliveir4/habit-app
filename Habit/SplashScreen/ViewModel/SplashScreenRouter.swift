//
//  SplashScreenRouter.swift
//  Habit
//
//  Created by Luis Filipe Alves de Oliveira on 04/04/23.
//

import SwiftUI

enum SplashScreenRouter {
    static func makeSignInView() -> some View {
        return SignInView(viewModel: SignInViewModel(interactor: SignInInteractor()))
    }

    static func makeHomeView() -> some View {
        return HomeView(viewModel: HomeViewModel())
    }
}
