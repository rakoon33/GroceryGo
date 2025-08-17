//
//  MainViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/6/25.
//

import SwiftUI

class MainViewModel: ObservableObject {
    static var shared: MainViewModel = MainViewModel()
    
    @Published var txtUsername: String = ""
    @Published var txtEmail: String = ""
    @Published var txtPassword: String = ""
    @Published var isShowPassword: Bool = false
    
    @Published var showError = false
    @Published var errorMessage: String = ""
    @Published var isUserLogin: Bool = false
    @Published var userObj: UserModel = UserModel(id: 0, username: "", name: "", email: "", mobile: "", mobileCode: "", authToken: "", createdDate: Date())
    
    init() {
        //        #if DEBUG
        //        txtUsername = "user4"
        //        txtEmail = "test@gmail.com"
        //        txtPassword = "123456"
        //        #endif
        
    }
    
    
    
    //MARK: ServiceCall
    
    func serviceCallLogin() {
        
        if(txtEmail.isEmpty || !txtEmail.isValidEmail) {
            self.errorMessage = "error_invalid_email".localized
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "error_invalid_password".localized
            self.showError = true
            return
        }
        
        ServiceCall.post(parameter: ["email": txtEmail, "password": txtPassword, "dervice_token": ""] ,path: Globs.SV_LOGIN) { responseObject in
            
            if let response = responseObject {
                let serverCode = (response[KKey.code] as? Int) ??
                Int(response[KKey.code] as? String ?? "")
                
                if serverCode == APISuccessCode.success {
                    
                    self.setUserData(userData: response)
                    
                } else {
                    self.errorMessage = response[KKey.message] as? String ?? "fail_message".localized
                    self.showError = true
                }
            }
            
        } failure: { netError in
            self.errorMessage = netError.errorMessage
            self.showError = true
        }
    }
    
    func serviceCallSignUp() {
        
        if(txtUsername.isEmpty) {
            self.errorMessage = "error_invalid_username".localized
            self.showError = true
            return
        }
        
        if(txtEmail.isEmpty || !txtEmail.isValidEmail) {
            self.errorMessage = "error_invalid_email".localized
            self.showError = true
            return
        }
        
        if(txtPassword.isEmpty) {
            self.errorMessage = "error_invalid_password".localized
            self.showError = true
            return
        }
        
        ServiceCall.post(parameter: ["username": txtUsername, "email": txtEmail, "password": txtPassword, "dervice_token": ""] ,path: Globs.SV_SIGN_UP) { responseObject in
            if let response = responseObject {
                let serverCode = (response[KKey.code] as? Int) ??
                Int(response[KKey.code] as? String ?? "")
                
                if serverCode == APISuccessCode.success {
                    
                    self.setUserData(userData: response)
                    
                } else {
                    self.errorMessage = response[KKey.message] as? String ?? "fail_message".localized
                    self.showError = true
                }
            }
            
        } failure: { netError in
            print(netError)
            self.errorMessage = netError.errorMessage
            self.showError = true
        }
    }
    
    func setUserData(userData : [String: Any]) {
        
        if let payload = userData[KKey.payload] {
            // 1. Lưu vào UserDefaults dạng Data JSON
            if let payloadData = try? JSONSerialization.data(withJSONObject: payload) {
                UserDefaults.standard.set(payloadData, forKey: Globs.userPayload)
            }
            
            // 2. Decode thành model
            if let payloadData = try? JSONSerialization.data(withJSONObject: payload) {
                let user = try? JSONDecoder().decode(UserModel.self, from: payloadData)
                // dùng user
            }
            
            // 3. Đánh dấu đã login
            UserDefaults.standard.set(true, forKey: Globs.userLogin)
            self.isUserLogin = true
        }
        
        self.txtEmail = ""
        self.txtUsername = ""
        self.txtPassword = ""
        self.isShowPassword = false
    }
}

