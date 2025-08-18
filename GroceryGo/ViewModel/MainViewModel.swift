//
//  MainViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/6/25.
//
import SwiftUI

class MainViewModel: ObservableObject {
    static let shared = MainViewModel()
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    
    // MARK: - Published state
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    @Published var isUserLogin: Bool = false
    @Published var userObj: UserModel = UserModel(
        id: 0, username: "", name: "", email: "",
        mobile: "", mobileCode: "", authToken: "",
        createdDate: Date()
    )
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService()) {
        
        
        #if DEBUG
        self.txtEmail = "test@gmail.com"
        self.txtPassword = "123456"
        self.txtUsername = "TestUser"
        #endif
        
        self.authService = authService
        
        // Load login state từ UserDefaults qua Utils
        self.isUserLogin = Utils.UDValueBool(key: Globs.userLogin)
        
        // Load userObj nếu có
        if let data = Utils.UDValue(key: Globs.userPayload) as? Data,
           let user = try? JSONDecoder().decode(UserModel.self, from: data) {
            self.userObj = user
        }
    }

    // MARK: - Public API
    func login() {
        guard validateLoginInputs() else { return }
        isLoading = true
        authService.login(email: txtEmail, password: txtPassword) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.setUserData(user: user)
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    func signUp() {
        guard validateSignUpInputs() else { return }
        isLoading = true
        authService.signUp(username: txtUsername, email: txtEmail, password: txtPassword) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let user):
                    self.setUserData(user: user)
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
    
    // MARK: - Validation
    private func validateLoginInputs() -> Bool {
        if txtEmail.isEmpty || !txtEmail.isValidEmail {
            errorMessage = "error_invalid_email".localized
            showError = true
            return false
        }
        if txtPassword.isEmpty {
            errorMessage = "error_invalid_password".localized
            showError = true
            return false
        }
        return true
    }
    
    private func validateSignUpInputs() -> Bool {
        if txtUsername.isEmpty {
            errorMessage = "error_invalid_username".localized
            showError = true
            return false
        }
        return validateLoginInputs()
    }
    
    // MARK: - Save user
    private func setUserData(user: UserModel) {
        // 1. Encode & save to UserDefaults
        if let userData = try? JSONEncoder().encode(user) {
            Utils.UDSET(data: userData, key: Globs.userPayload)
        }
        
        // 2. Update state
        self.userObj = user
        Utils.UDSET(data: true, key: Globs.userLogin)
        self.isUserLogin = true
        
        // 3. Reset input
        self.txtEmail = ""
        self.txtUsername = ""
        self.txtPassword = ""
        self.isShowPassword = false
    }
}
