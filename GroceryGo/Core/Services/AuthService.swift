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
            parameter: ["email": email, "password": password, "dervice_token": ""],
            path: Globs.SV_LOGIN
        ) { responseObject in
            guard let response = responseObject,
                  let serverCode = (response[KKey.code] as? Int) ??
                                   Int(response[KKey.code] as? String ?? ""),
                  serverCode == APISuccessCode.success,
                  let payload = response[KKey.payload],
                  let payloadData = try? JSONSerialization.data(withJSONObject: payload)
            else {
                completion(.failure(.unknown(code: -1, message: "fail_message")))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted({
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                    f.locale = Locale(identifier: "en_US_POSIX")
                    return f
                }())
                let user = try decoder.decode(UserModel.self, from: payloadData)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingError(message: error.localizedDescription)))
            }

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
            parameter: [
                "email": email,
                "password": password,
                "username": username,
                "dervice_token": ""
            ],
            path: Globs.SV_SIGN_UP
        ) { responseObject in
            guard let response = responseObject,
                  let serverCode = (response[KKey.code] as? Int) ??
                                   Int(response[KKey.code] as? String ?? ""),
                  serverCode == APISuccessCode.success,
                  let payload = response[KKey.payload],
                  let payloadData = try? JSONSerialization.data(withJSONObject: payload)
            else {
                completion(.failure(.unknown(code: -1, message: "fail_message")))
                return
            }

            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(UserModel.self, from: payloadData)
                completion(.success(user))
            } catch let decodingError as DecodingError {
                completion(.failure(.decodingError(message: decodingError.detailedMessage)))
            } catch {
                completion(.failure(.unknown(code: -1, message: "fail_message")))
            }

        } failure: { netError in
            completion(.failure(netError))
        }
    }

}
