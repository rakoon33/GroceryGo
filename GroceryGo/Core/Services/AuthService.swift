//
//  AuthService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 17/8/25.
//

import Foundation

protocol AuthServiceProtocol {
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, NetworkErrorType>) -> Void
    )
    
    func signUp(
        username: String,
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, NetworkErrorType>) -> Void
    )
}

final class AuthService: AuthServiceProtocol {
    
    func login(
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, NetworkErrorType>) -> Void
    ) {
        ServiceCall.post(
            parameter: ["email": email, "password": password, "device_token": ""],
            path: Globs.SV_LOGIN
        ) { responseObject in
            guard let response = responseObject,
                  let serverCode = (response[KKey.code] as? Int) ??
                                   Int(response[KKey.code] as? String ?? ""),
                  serverCode == APISuccessCode.success,
                  let payload = response[KKey.payload],
                  let payloadData = try? JSONSerialization.data(withJSONObject: payload),
                  let user = try? JSONDecoder().decode(UserModel.self, from: payloadData)
            else {
                completion(.failure(.unknown(code: -1, message: "Login failed")))
                return
            }
            completion(.success(user))
            
        } failure: { netError in
            completion(.failure(netError))
        }
    }
    
    func signUp(
        username: String,
        email: String,
        password: String,
        completion: @escaping (Result<UserModel, NetworkErrorType>) -> Void
    ) {
        ServiceCall.post(
            parameter: ["username": username, "email": email, "password": password, "device_token": ""],
            path: Globs.SV_SIGN_UP
        ) { responseObject in
            guard let response = responseObject,
                  let serverCode = (response[KKey.code] as? Int) ??
                                   Int(response[KKey.code] as? String ?? ""),
                  serverCode == APISuccessCode.success,
                  let payload = response[KKey.payload],
                  let payloadData = try? JSONSerialization.data(withJSONObject: payload),
                  let user = try? JSONDecoder().decode(UserModel.self, from: payloadData)
            else {
                completion(.failure(.unknown(code: -1, message: "Signup failed")))
                return
            }
            completion(.success(user))
            
        } failure: { netError in
            completion(.failure(netError))
        }
    }
}
