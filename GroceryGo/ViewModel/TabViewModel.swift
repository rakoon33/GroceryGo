//
//  TabViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI

@MainActor
final class TabViewModel: ObservableObject {
    @Published var selectedTab: MainTab = .shop
}
    