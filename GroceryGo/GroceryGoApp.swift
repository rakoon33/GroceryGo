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
    @StateObject private var tabVM = TabViewModel()
  
    // Khởi tạo các manager
    @StateObject private var navigationState = NavigationManager()

    // Sử dụng singleton thay vì tạo mới
    @StateObject private var loadingState = LoadingManager.shared
    @StateObject private var popupState = PopupManager.shared
    
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
            ZStack {
                ContentView()
                    .environmentObject(localization)
                    .environmentObject(tabVM)
                // Inject 3 manager từ AppState
                    .environmentObject(navigationState)
                
                // Overlay Popup
                if popupState.showPopup {
                    ZStack {
                        Color.black.opacity(0.4).ignoresSafeArea()
                        StatusPopupView(
                            type: popupState.popupType,
                            messageKey: LocalizedStringKey(popupState.popupMessageKey),
                            buttonKey: "ok_button"
                        ) {
                            withAnimation {
                                popupState.dismissPopup()
                            }
                        }
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(), value: popupState.showPopup)
                    }
                    .zIndex(1)
                }
                
                // Overlay Spinner
                if loadingState.isLoading {
                    SpinnerView(isLoading: .constant(true))
                        .zIndex(2)
                }
            }
        }
        
    }
}
