//
//  KeychainManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/8/25.
//


import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}

    func save(_ value: String, for key: String) {
        let data = Data(value.utf8)
        delete(key) // xoá trước nếu đã có
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    func read(_ key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == errSecSuccess,
           let data = dataTypeRef as? Data,
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return nil
    }

    func delete(_ key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
