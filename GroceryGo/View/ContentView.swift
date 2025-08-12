//
//  ContentView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import SwiftUI

struct ContentView: View {
    @State private var path = NavigationPath()
    @State private var hasSeenWelcome: Bool = UserDefaults.standard.bool(forKey: "hasSeenWelcome")
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if hasSeenWelcome {
                    SignInView(path: $path)
                } else {
                    WelcomeView(path: $path) {
                        UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
                        hasSeenWelcome = true
                    }
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .login:
                    LoginView(path: $path)
                case .signup:
                    SignUpView(path: $path)
                case .signin:
                    SignInView(path: $path)
                }
            }
        }
    }
}

enum AppRoute: Hashable {
    case login
    case signup
    case signin
}
