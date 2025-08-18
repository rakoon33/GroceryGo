//
//  ContentView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import SwiftUI

enum AppRoute: Hashable {
    case welcome
    case login
    case signup
    case signin
    case mainTab
}

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var hasSeenWelcome = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    @StateObject var mainVM = MainViewModel.shared
    
    var body: some View {
        NavigationStack(path: $path) {
            // Root view trống (Splash)
            Color.clear
                .ignoresSafeArea()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .welcome:
                        WelcomeView(path: $path)
                    case .login:
                        LoginView(path: $path)
                    case .signup:
                        SignUpView(path: $path)
                    case .signin:
                        SignInView(path: $path)
                    case .mainTab:
                        MainTabView(path: $path)
                    }
                }
                .onAppear {
                    
                    path.removeLast(path.count)
                    
                    if !hasSeenWelcome {
                        path.append(AppRoute.welcome)
                    } else if !mainVM.isUserLogin {
                        path.append(AppRoute.signin)
                    } else {
                        path.append(AppRoute.mainTab)
                    }
                }
                .onChange(of: mainVM.isUserLogin) { newValue in

                    if newValue {
                        // Login thành công → đi thẳng MainTab
                        path.append(AppRoute.mainTab)
                    } else {
                        path.removeLast(path.count) // reset path
                        // Logout → về Login
                        path.append(AppRoute.signin)
                    }
                }
        }
    }
}
