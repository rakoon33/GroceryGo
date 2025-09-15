//
//  AuthService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 17/8/25.
//

import Foundation

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> UserModel
    func signUp(username: String, email: String, password: String) async throws -> UserModel
}

final class AuthService: AuthServiceProtocol {

    func login(email: String, password: String) async throws -> UserModel {
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "dervice_token": "" 
        ]
        
        let user: UserModel = try await ServiceCall.post(
            path: Globs.SV_LOGIN,
            parameters: params,
            isTokenRequired: false,
            responseType: UserModel.self
        )
        return user
    }
    
    func signUp(username: String, email: String, password: String) async throws -> UserModel {
        let params: [String: Any] = [
            "email": email,
            "password": password,
            "username": username,
            "dervice_token": ""
        ]
        
        let user: UserModel = try await ServiceCall.post(
            path: Globs.SV_SIGN_UP,
            parameters: params,
            isTokenRequired: false,
            responseType: UserModel.self
        )
        return user
    }
}
