//
//  AuthManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import Foundation

final class AuthManager {
    static let shared = AuthManager()
    private init() {}
    
    var token: String {
        // đọc từ UserDefaults / Keychain / MainVM tùy ý
        return MainViewModel.shared.userObj.authToken
    }
}
