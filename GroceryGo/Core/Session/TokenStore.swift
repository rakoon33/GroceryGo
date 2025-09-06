//
//  TokenStore.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 3/9/25.
//


import Foundation

protocol TokenStore {
    var token: String? { get set }
    func clear() throws
}

final class KeychainTokenStore: TokenStore {
    private let tokenKey = "authToken"
    
    var token: String? {
        get {
            do {
                return try KeychainManager.shared.read(tokenKey)
            } catch {
                AppLogger.error("Keychain read error for key=\(tokenKey): \(error.localizedDescription)", category: .session)
                return nil
            }
        }
        set {
            do {
                if let value = newValue {
                    try KeychainManager.shared.save(value, for: tokenKey)
                } else {
                    try KeychainManager.shared.delete(tokenKey)
                }
            } catch {
                AppLogger.error("Keychain save/delete error for key=\(tokenKey): \(error.localizedDescription)", category: .session)
            }
        }
    }
    
    func clear() throws {
        try KeychainManager.shared.delete(tokenKey)
        AppLogger.info("Token cleared from Keychain", category: .session)
    }
}
