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
            // Ép app dùng Tiếng Việt/Anh
            UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


