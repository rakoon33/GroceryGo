//
//  UserStore.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 3/9/25.
//


import Foundation

protocol UserStore {
    var currentUser: UserModel? { get set }
    func clear()
}

final class DefaultUserStore: UserStore {
    private let userKey = Globs.userPayload
    
    var currentUser: UserModel? {
        get {
            if let data = Utils.UDValue(key: userKey) as? Data {
                do {
                    let user = try JSONDecoder().decode(UserModel.self, from: data)
                    return user
                } catch {
                    AppLogger.error("Failed to decode UserModel from UserDefaults for key=\(userKey): \(error.localizedDescription)", category: .session)
                    return nil
                }
            }
            AppLogger.info("No current user found in UserDefaults for key=\(userKey)", category: .session)
            return nil
        }
        set {
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                Utils.UDSET(data: data, key: userKey)
                AppLogger.info("Saved current user to UserDefaults: \(newValue.username)", category: .session)
            } else {
                Utils.UDRemove(key: userKey)
                AppLogger.info("Removed current user from UserDefaults", category: .session)
            }
        }
    }
    
    func clear() {
        Utils.UDRemove(key: userKey)
        AppLogger.info("UserStore cleared for key=\(userKey)", category: .session)
    }
}
