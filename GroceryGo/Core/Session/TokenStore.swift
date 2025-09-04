//
//  TokenStore.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 3/9/25.
//


import Foundation

protocol TokenStore {
    var token: String? { get set }
    func clear()
}

final class KeychainTokenStore: TokenStore {
    private let tokenKey = "authToken"
    
    var token: String? {
        get { KeychainManager.shared.read(tokenKey) }
        set {
            if let value = newValue {
                KeychainManager.shared.save(value, for: tokenKey)
            } else {
                KeychainManager.shared.delete(tokenKey)
            }
        }
    }
    
    func clear() {
        KeychainManager.shared.delete(tokenKey)
    }
}
