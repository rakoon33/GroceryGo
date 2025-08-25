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
                ExploreView()
            case .cart:
                ExploreView()
            case .favorite:
                FavouriteView(path: $path)
            case .account:
                ExploreView() //
            }
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    TabButton(title: "Shop", icon: "store_tab", isSelected: homeVM.selectedTab == .shop) {
                        
                        withAnimation { homeVM.selectedTab = .shop }
                        
                    }
                    TabButton(title: "Explore", icon: "explore_tab", isSelected: homeVM.selectedTab == .explore) {
                        
                        withAnimation { homeVM.selectedTab = .explore }
                    }
                    TabButton(title: "Cart", icon: "cart_tab", isSelected: homeVM.selectedTab == .cart) {
                        
                        withAnimation { homeVM.selectedTab = .cart }
                        
                    }
                    TabButton(title: "Favorite", icon: "fav_tab", isSelected: homeVM.selectedTab == .favorite) {
                        
                        withAnimation { homeVM.selectedTab = .favorite }
                        
                    }
                    TabButton(title: "Account", icon: "account_tab", isSelected: homeVM.selectedTab == .account) {
                        
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
