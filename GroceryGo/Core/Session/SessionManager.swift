//
//  SessionManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/8/25.
//

import SwiftUI

final class SessionManager: ObservableObject {
    static let shared = SessionManager()
    
    @Published private(set) var user: UserModel?
    
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
        self.user = userStore.currentUser
    }
    
    func setUser(_ user: UserModel) {
        self.user = user
        self.tokenStore.token = user.authToken
        self.userStore.currentUser = user
        Utils.UDSET(data: true, key: Globs.userLogin)
    }
    
    func logout() {
        self.user = nil
        tokenStore.clear()
        userStore.clear()
        Utils.UDRemove(key: Globs.userLogin)
    }
    
    var isLoggedIn: Bool {
        user != nil && !(tokenStore.token ?? "").isEmpty
    }
}
