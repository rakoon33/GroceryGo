//
//  KeychainManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/8/25.
//


import Foundation
import Security

// MARK: - Keychain Manager (Singleton, reusable)
final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    // Save any Data
    func save(_ data: Data, for key: String) {
        delete(key) // xoá trước nếu đã có
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    // Read as Data
    func read(_ key: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess {
            return dataTypeRef as? Data
        }
        return nil
    }

    // Delete
    func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
