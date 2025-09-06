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
        
        ZStack {
            
            switch homeVM.selectedTab {
            case .shop:
                HomeView(path: $path)
            case .explore:
                ExploreView(path: $path)
            case .cart:
                ExploreView(path: $path)
            case .favorite:
                FavouriteView(path: $path)
            case .account:
                ExploreView(path: $path) //
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    TabButton(title: "tab_shop", icon: "store_tab", isSelected: homeVM.selectedTab == .shop) {
                        
                        withAnimation { homeVM.selectedTab = .shop }
                        
                    }
                    TabButton(title: "tab_explore", icon: "explore_tab", isSelected: homeVM.selectedTab == .explore) {
                        
                        withAnimation { homeVM.selectedTab = .explore }
                    }
                    TabButton(title: "tab_cart", icon: "cart_tab", isSelected: homeVM.selectedTab == .cart) {
                        
                        withAnimation { homeVM.selectedTab = .cart }
                        
                    }
                    TabButton(title: "tab_favorite", icon: "fav_tab", isSelected: homeVM.selectedTab == .favorite) {
                        
                        withAnimation { homeVM.selectedTab = .favorite }
                        
                    }
                    TabButton(title: "tab_account", icon: "account_tab", isSelected: homeVM.selectedTab == .account) {
                        
                        withAnimation { homeVM.selectedTab = .account }
                        
                    }
                    
                }
                .padding(.top, 10)
                .padding(.bottom, .bottomInsets)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.15), radius: 3, x: 0, y: -2)
            }
            
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        
    }
}


#Preview {
    MainTabView(path: .constant(NavigationPath()))
}
