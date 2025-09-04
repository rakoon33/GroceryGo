import Foundation

protocol TokenStore {
    var token: String? { get set }
    func clear()
}

final class KeychainTokenStore: TokenStore {
    static let shared = KeychainTokenStore()
    private init() {}
    
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
