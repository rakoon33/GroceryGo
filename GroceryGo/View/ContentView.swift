//
//  ContentView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import SwiftUI

enum AccountRoute: Hashable {
    case orders
    case myDetails
    case deliveryAddress
    case paymentMethods
    case promoCode
    case notifications
    case help
    case about
}

enum AppRoute: Hashable {
    case welcome
    case login
    case signup
    case signin
    case mainTab
    
    // cross-domain detail
    case productDetail(ProductModel)
    case exploreDetail(CategoryModel)
    
    // grouped by domain
    case account(AccountRoute)
}

struct ContentView: View {
    @EnvironmentObject var navigation: NavigationManager
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false
    @StateObject private var session = SessionManager.shared
    @EnvironmentObject var tabVM: TabViewModel
    
    var body: some View {
        
        NavigationStack(path: $navigation.path) {
            // Root view trống (Splash)
            Color.clear
                .toolbar(.hidden, for: .navigationBar)
                .ignoresSafeArea()
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .welcome:
                        WelcomeView()
                    case .login:
                        LoginView()
                    case .signup:
                        SignUpView()
                    case .signin:
                        SignInView()
                    case .mainTab:
                        MainTabView()
                    case .productDetail(let product):
                        ProductDetailView(
                            detailVM: ProductDetailViewModel(prodObj: product)
                        )
                        
                    case .exploreDetail(let category):
                        ExploreItemView(
                            itemsVM: ExploreItemViewModel(cObj: category)
                        )
                    case .account(let accRoute):
                        switch accRoute {
                        case .orders:
                            MyOrdersView()
                        case .deliveryAddress:
                            DelieryAddressView()
                        case .myDetails:
                            MyDetailsView()
                        case .paymentMethods:
                            PaymentMethodsView()
                        case .promoCode:
                            PromoCodeView()
                        case .notifications:
                            NotificationView()
                        case .help:
                            HelpView()
                        case .about:
                            AboutView()
                        }
                        
                    }
                }
                .onAppear {
                    navigation.resetNavigation()
                    
                    if !hasSeenWelcome {
                        // Người dùng chưa vào app lần nào → Welcome
                        navigation.navigate(to: .welcome)
                    } else if !session.isLoggedIn {
                        // Chưa login → SignIn
                        navigation.navigate(to: .signin)
                    } else {
                        // Đã login → MainTab
                        navigation.navigate(to: .mainTab)
                    }
                }
                .onChange(of: session.isLoggedIn) { newValue in
                    if newValue {
                        // Login thành công → đi thẳng MainTab
                        navigation.resetNavigation()
                        navigation.navigate(to: .mainTab)
                    } else {
                        navigation.resetNavigation()
                        // Logout hoặc token hết hạn → về SignIn
                        navigation.navigate(to: .signin)
                    }
                }
        }
    }
}
