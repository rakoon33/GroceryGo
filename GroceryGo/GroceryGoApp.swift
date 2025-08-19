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

            Utils.UDSET(data: true, key: Globs.userLogin)
        }
    
    var body: some Scene {
        WindowGroup {
            MainTabView(path:  .constant(NavigationPath()))
        }
    }
}


    
