//
//  MainTabView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 15/8/25.
//

import SwiftUI

enum MainTab: Int {
    case shop
    case explore
    case cart
    case favorite
    case account
}

struct MainTabView: View {
    
    @Binding var path: NavigationPath
    @StateObject var homeVM = HomeViewModel.shared
    
    
    var body: some View {
        VStack {
            
            TabView(selection: $homeVM.selectedTab) {
                HomeView()
                    .tag(MainTab.shop)
                
                ExploreView()
                    .tag(MainTab.explore)
                
                ExploreView()
                    .tag(MainTab.cart)
                
                ExploreView()
                    .tag(MainTab.favorite)
                
                ExploreView()
                    .tag(MainTab.account)
            }
            .onAppear {
                UIScrollView.appearance().isScrollEnabled = false
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .onChange(of: homeVM.selectedTab) { newValue in
                debugPrint("tab:", newValue)
            }
    
            HStack {
                
                TabButton(title: "Shop", icon: "store_tab", isSelected: homeVM.selectedTab == .shop) {
                    DispatchQueue.main.async {
                        withAnimation { homeVM.selectedTab = .shop }
                    }
                    
                    
                }
                TabButton(title: "Explore", icon: "explore_tab", isSelected: homeVM.selectedTab == .explore) {

                    DispatchQueue.main.async {
                        withAnimation { homeVM.selectedTab = .explore }
                    }
                }
                TabButton(title: "Cart", icon: "cart_tab", isSelected: homeVM.selectedTab == .cart) {

                    DispatchQueue.main.async {
                        withAnimation { homeVM.selectedTab = .cart }
                    }
                }
                TabButton(title: "Favorite", icon: "fav_tab", isSelected: homeVM.selectedTab == .favorite) {
                    DispatchQueue.main.async {
                        withAnimation { homeVM.selectedTab = .favorite }
                    }
                }
                TabButton(title: "Account", icon: "account_tab", isSelected: homeVM.selectedTab == .account) {
                    
                    DispatchQueue.main.async {
                        withAnimation { homeVM.selectedTab = .account }
                    }
                }
                
            }
            
            .padding(.top, 10)
            .padding(.bottom, .bottomInsets)
            .padding(.horizontal, 10)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: -2)
            
            
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        
    }
}


#Preview {
    MainTabView(path: .constant(NavigationPath()))
}
