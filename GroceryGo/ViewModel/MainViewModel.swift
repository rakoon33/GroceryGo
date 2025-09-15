//
//  MainViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/6/25.
//

import SwiftUI

@MainActor
class MainViewModel: ObservableObject {
    static let shared = MainViewModel()
    
    // MARK: - Dependencies
    private let authService: AuthServiceProtocol
    private let session = SessionManager.shared
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    // MARK: - Published state
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false
    
    // Expose từ Session
    @Published private(set) var isUserLogin: Bool = false
    @Published private(set) var userObj: UserModel = UserModel()
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        
        if let user = session.user {
            self.userObj = user
            self.isUserLogin = true
        }
        
#if DEBUG
        self.txtEmail = "test@gmail.com"
        self.txtPassword = "123456"
        self.txtUsername = "TestUser"
        

#endif
    }
    
    func login() async {
        guard validateLoginInputs() else { return }
        loadingState.isLoading = true
        AppLogger.debug("Attempting login for email=\(txtEmail)", category: .session)
        
        defer { loadingState.isLoading = false }
        do {
            let user = try await authService.login(email: txtEmail, password: txtPassword)
            session.setUser(user)
            self.userObj = user
            self.isUserLogin = true
            resetForm()
            AppLogger.info("Login success: \(user.username)", category: .session)
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Login failed: \(error as? NetworkErrorType)?.errorMessage)", category: .session)
        }
    }
    
    func signUp() async {
        guard validateSignUpInputs() else { return }
        loadingState.isLoading = true
        AppLogger.debug("Attempting signup for username=\(txtUsername), email=\(txtEmail)", category: .session)
        
        defer { loadingState.isLoading = false }
        do {
            let user = try await authService.signUp(username: txtUsername, email: txtEmail, password: txtPassword)
            session.setUser(user)
            self.userObj = user
            self.isUserLogin = true
            resetForm()
            AppLogger.info("Signup success: \(user.username)", category: .session)
            popupState.showSuccessPopup("signup_success_message")
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Signup failed: \(error.localizedDescription)", category: .session)
        }
    }
    
    // MARK: - Validation
    private func validateLoginInputs() -> Bool {
        if txtEmail.isEmpty || !txtEmail.isValidEmail {
            popupState.showErrorPopup("error_invalid_email".localized)
            return false
        }
        if txtPassword.isEmpty {
            popupState.showErrorPopup("error_invalid_password".localized)
            return false
        }
        return true
    }
    
    private func validateSignUpInputs() -> Bool {
        if txtUsername.isEmpty {
            popupState.showErrorPopup("error_invalid_username".localized)
            return false
        }
        return validateLoginInputs()
    }
    
    // MARK: - Helpers
    private func resetForm() {
        txtEmail = ""
        txtUsername = ""
        txtPassword = ""
        isShowPassword = false
    }
}

extension MainViewModel: Resettable {
    func reset() {
        txtUsername = ""
        txtEmail = ""
        txtPassword = ""
        isShowPassword = false
        isUserLogin = false
        userObj = UserModel()
    }
}
