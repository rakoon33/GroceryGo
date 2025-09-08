//
//  SessionManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/8/25.
//

import SwiftUI

@MainActor
final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published private(set) var user: UserModel?
    @Published private(set) var isLoggedIn: Bool = false
    
    private var tokenStore: TokenStore
    private var userStore: UserStore
    
    var token: String {
        tokenStore.token ?? ""
    }
    
    private init(
        tokenStore: TokenStore = KeychainTokenStore(),
        userStore: UserStore = DefaultUserStore()
    ) {
        self.tokenStore = tokenStore
        self.userStore = userStore
        if let savedUser = userStore.currentUser,
           let token = tokenStore.token, !token.isEmpty {
            self.user = savedUser
            self.isLoggedIn = true
        } else {
            self.user = nil
            self.isLoggedIn = false
        }
    }
    
    func setUser(_ user: UserModel) {
        self.user = user
        self.tokenStore.token = user.authToken
        self.userStore.currentUser = user
        Utils.UDSET(data: true, key: Globs.userLogin)
        isLoggedIn = true
        AppLogger.info("User logged in: \(user.username)", category: .session)
    }
    
    func logout() {
        self.user = nil
        do {
            try tokenStore.clear()
            AppLogger.info("Token cleared on logout", category: .session)
        } catch {
            AppLogger.error("Failed to clear token on logout: \(error.localizedDescription)", category: .session)
        }
        userStore.clear()
        
        Utils.UDRemove(key: Globs.userLogin)
        
        // Reset global ViewModels
        HomeViewModel.shared.reset()
        CartViewModel.shared.reset()
        ExploreViewModel.shared.reset()
        FavouriteViewModel.shared.reset()
        MainViewModel.shared.reset()
        
        isLoggedIn = false
        
        AppLogger.info("User logged out, state cleared", category: .session)
    }
    
}
