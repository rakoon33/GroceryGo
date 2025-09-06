//
//  GroceryGoApp.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/3/25.
//

import SwiftUI


@main
struct GroceryGoApp: App {
    
    @StateObject private var localization = LocalizationManager.shared
    
    init() {
        // Ẩn TabBar hệ thống
        UITabBar.appearance().isHidden = true
        
        // Cấu hình log level từ UserDefaults (phải đặt ở init để chạy sớm nhất)
        AppLogger.configureFromDefaults()
        
        // Bật CrashReporter
        CrashReporter.shared.start()
        
        

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localization)
        }
    }
}
