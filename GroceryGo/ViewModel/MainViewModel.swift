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
    private let session: SessionManager
    
    // MARK: - Published state
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false
    @Published var isLoading: Bool = false
    
    @Published var showPopup = false
    @Published var popupType: PopupType = .success
    @Published var popupMessageKey: String = ""
    
    // Expose từ Session
    @Published private(set) var isUserLogin: Bool = false
    @Published private(set) var userObj: UserModel = UserModel()
    
    // MARK: - Init
    init(authService: AuthServiceProtocol = AuthService()) {
        self.authService = authService
        self.session = SessionManager.shared
        
        if let user = session.user {
            self.userObj = user
            self.isUserLogin = true
        }
        
#if DEBUG
        self.txtEmail = "test@gmail.com"
        self.txtPassword = "123456"
        self.txtUsername = "TestUser"
        
        let mockUser = UserModel.mock
        session.setUser(mockUser)
        self.userObj = mockUser
        self.isUserLogin = true
#endif
    }
    
    func login() async {
        guard validateLoginInputs() else { return }
        isLoading = true
        AppLogger.debug("Attempting login for email=\(txtEmail)", category: .session)
        
        defer { isLoading = false }
        do {
            let user = try await authService.login(email: txtEmail, password: txtPassword)
            session.setUser(user)
            self.userObj = user
            self.isUserLogin = true
            resetForm()
            AppLogger.info("Login success: \(user.username)", category: .session)
        } catch let error as NetworkErrorType {
            popupType = .error
            popupMessageKey = error.errorMessage
            showPopup = true
        } catch {
            popupType = .error
            popupMessageKey = (error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription
            showPopup = true
            AppLogger.error("Login failed: \(popupMessageKey)", category: .session)
        }
    }
    
    func signUp() async {
        guard validateSignUpInputs() else { return }
        isLoading = true
        AppLogger.debug("Attempting signup for username=\(txtUsername), email=\(txtEmail)", category: .session)
        
        defer { isLoading = false }
        do {
            let user = try await authService.signUp(username: txtUsername, email: txtEmail, password: txtPassword)
            session.setUser(user)
            self.userObj = user
            self.isUserLogin = true
            resetForm()
            AppLogger.info("Signup success: \(user.username)", category: .session)
        } catch let error as NetworkErrorType {
            popupType = .error
            popupMessageKey = error.errorMessage
            showPopup = true
        } catch {
            popupType = .error
            popupMessageKey = (error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription
            showPopup = true
            AppLogger.error("Signup failed: \(popupMessageKey)", category: .session)
        }
    }
    
    // MARK: - Validation
    private func validateLoginInputs() -> Bool {
        if txtEmail.isEmpty || !txtEmail.isValidEmail {
            popupType = .error
            popupMessageKey = "error_invalid_email".localized
            showPopup = true
            return false
        }
        if txtPassword.isEmpty {
            popupType = .error
            popupMessageKey = "error_invalid_password".localized
            showPopup = true
            return false
        }
        return true
    }
    
    private func validateSignUpInputs() -> Bool {
        if txtUsername.isEmpty {
            popupType = .error
            popupMessageKey = "error_invalid_username".localized
            showPopup = true
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
        isLoading = false
        showPopup = false
        popupType = .success
        popupMessageKey = ""
        isUserLogin = false
        userObj = UserModel()
    }
}
