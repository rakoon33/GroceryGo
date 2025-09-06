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
    case productDetail(ProductModel)
    case exploreDetail(CategoryModel)
}

struct ContentView: View {
    @State private var path = NavigationPath()
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @StateObject private var session = SessionManager.shared
    
    var body: some View {
        
        NavigationStack(path: $path) {
            // Root view trống (Splash)
            Color.clear
                .toolbar(.hidden, for: .navigationBar)
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
                    case .productDetail(let product):
                        ProductDetailView(
                            path: $path,
                            detailVM: ProductDetailViewModel(prodObj: product)
                        )
                        
                    case .exploreDetail(let category):
                        ExploreItemView(
                            path: $path,
                            itemsVM: ExploreItemViewModel(cObj: category)
                        )
                    }
                    
                }
                .onAppear {
                    
                    path = NavigationPath()
                    
                    if !hasSeenWelcome {
                        // Người dùng chưa vào app lần nào → Welcome
                        path.append(AppRoute.welcome)
                    } else if !session.isLoggedIn {
                        // Chưa login → SignIn
                        path.append(AppRoute.signin)
                    } else {
                        // Đã login → MainTab
                        path.append(AppRoute.mainTab)
                    }
                }
                .onChange(of: session.isLoggedIn) { newValue in
                    
                    if newValue {
                        // Login thành công → đi thẳng MainTab
                        path = NavigationPath()
                        path.append(AppRoute.mainTab)
                    } else {
                        path = NavigationPath()
                        // Logout hoặc token hết hạn → về SignIn
                        path.append(AppRoute.signin)
                    }
                }
        }
    }
}
