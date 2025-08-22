//
//  ServiceCall.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 8/8/25.
//

import SwiftUI

final class ServiceCall {
    class func post(
        parameter: [String: Any],
        isTokenRequired: Bool = false,
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .POST, path: path, parameters: parameter, isTokenRequired: isTokenRequired) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }

    class func put(
        parameter: [String: Any],
        isTokenRequired: Bool = false,
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .PUT, path: path, parameters: parameter, isTokenRequired: isTokenRequired) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }

    class func delete(
        isTokenRequired: Bool = false,
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .DELETE, path: path, parameters: nil, isTokenRequired: isTokenRequired) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }

    class func get(
        isTokenRequired: Bool = false,
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .GET, path: path, parameters: nil, isTokenRequired: isTokenRequired) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
