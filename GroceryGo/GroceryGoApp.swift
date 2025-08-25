//
//  GroceryGoApp.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/3/25.
//

import SwiftUI

@main
struct GroceryGoApp: App {
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


