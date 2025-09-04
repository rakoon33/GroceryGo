@MainActor
final class SessionManager: ObservableObject {
    @Published private(set) var currentUser: UserModel?
    private let tokenStore: TokenStore
    
    init(tokenStore: TokenStore) {
        self.tokenStore = tokenStore
        if let data = Utils.UDValue(key: Globs.userPayload) as? Data,
           let user = try? JSONDecoder().decode(UserModel.self, from: data) {
            self.currentUser = user
        }
    }
    
    func setUser(_ user: UserModel) {
        if let data = try? JSONEncoder().encode(user) {
            Utils.UDSET(data: data, key: Globs.userPayload)
        }
        Utils.UDSET(data: true, key: Globs.userLogin)
        
        tokenStore.token = user.authToken
        currentUser = user
    }
    
    func logout() {
        Utils.UDRemove(key: Globs.userPayload)
        Utils.UDRemove(key: Globs.userLogin)
        
        tokenStore.token = nil
        tokenStore.refreshToken = nil
        currentUser = nil
    }
    
    var isLoggedIn: Bool {
        currentUser != nil
    }
}
