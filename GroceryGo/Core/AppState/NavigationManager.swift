//
//  NavigationManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 12/9/25.
//


import SwiftUI

@MainActor
final class NavigationManager: ObservableObject {
    @Published var path = NavigationPath()
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func resetNavigation() {
        path = NavigationPath()
    }
    
    func removeLast() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
}
