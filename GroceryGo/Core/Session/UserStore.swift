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
                return try? JSONDecoder().decode(UserModel.self, from: data)
            }
            return nil
        }
        set {
            if let newValue = newValue,
               let data = try? JSONEncoder().encode(newValue) {
                Utils.UDSET(data: data, key: userKey)
            } else {
                Utils.UDRemove(key: userKey)
            }
        }
    }
    
    func clear() {
        Utils.UDRemove(key: userKey)
    }
}
