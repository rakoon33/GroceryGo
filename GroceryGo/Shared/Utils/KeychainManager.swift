//
//  KeychainManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/8/25.
//


import Foundation
import Security

enum KeychainError: Error, LocalizedError {
    case unhandled(OSStatus)
    
    var errorDescription: String? {
        switch self {
        case .unhandled(let status):
            if let message = SecCopyErrorMessageString(status, nil) as String? {
                return "Keychain error (\(status)): \(message)"
            }
            return "Keychain error (\(status))"
        }
    }
}

//Chỉ hỗ trợ String. Không có generic encode/decode (Codable). Muốn lưu struct/token phức tạp thì phải encode JSON thủ công.
final class KeychainManager {
    static let shared = KeychainManager()
    private init() {}
    
    func save(_ value: String, for key: String) throws {
        let data = Data(value.utf8)
        let query: [String: Any] = [
            kSecClass as String            : kSecClassGenericPassword,
            kSecAttrAccount as String      : key,
            kSecValueData as String        : data,
            kSecAttrAccessible as String   : kSecAttrAccessibleAfterFirstUnlock
        ]
        
        // thử update trước
        let status = SecItemUpdate(
            [kSecClass as String: kSecClassGenericPassword,
             kSecAttrAccount as String: key] as CFDictionary,
            [kSecValueData as String: data] as CFDictionary
        )
        
        switch status {
        case errSecSuccess:
            return // update thành công
        case errSecItemNotFound:
            // chưa có → add mới
            let addStatus = SecItemAdd(query as CFDictionary, nil)
            guard addStatus == errSecSuccess else {
                AppLogger.error("Keychain save failed for key=\(key), status=\(addStatus)", category: .session)
                throw KeychainError.unhandled(addStatus)
            }
        default:
            AppLogger.error("Keychain update failed for key=\(key), status=\(status)", category: .session)
            throw KeychainError.unhandled(status)
        }
    }
    
    func read(_ key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        switch status {
        case errSecSuccess:
            if let data = dataTypeRef as? Data,
               let str = String(data: data, encoding: .utf8) {
                return str
            }
            AppLogger.error("Keychain decode failed for key=\(key)", category: .session)
            return nil
        case errSecItemNotFound:
            AppLogger.info("Keychain read: no item found for key=\(key)", category: .session)
            return nil
        default:
            AppLogger.error("Keychain read failed for key=\(key), status=\(status)", category: .session)
            throw KeychainError.unhandled(status)
        }
    }
    
    func delete(_ key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        if !(status == errSecSuccess || status == errSecItemNotFound) {
            AppLogger.error("Keychain delete failed for key=\(key), status=\(status)", category: .session)
            throw KeychainError.unhandled(status)
        }
    }
}
