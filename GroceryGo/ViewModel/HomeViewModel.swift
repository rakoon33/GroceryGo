//
//  HomeViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
  
    static var shared: HomeViewModel = HomeViewModel()
    
    @Published var selectedTab: MainTab = .shop
    
}

