//
//  ServiceCall.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 8/8/25.
//

import SwiftUI
import Foundation

final class ServiceCall {
    
    // MARK: - Convenience wrappers
    class func get<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        try await NetworkManager.shared.request(
            method: .GET,
            path: path,
            parameters: parameters,
            isTokenRequired: isTokenRequired,
            headers: headers,
            responseType: responseType
        )
    }
    
    class func post<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        try await NetworkManager.shared.request(
            method: .POST,
            path: path,
            parameters: parameters,
            isTokenRequired: isTokenRequired,
            headers: headers,
            responseType: responseType
        )
    }
    
    class func put<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        try await NetworkManager.shared.request(
            method: .PUT,
            path: path,
            parameters: parameters,
            isTokenRequired: isTokenRequired,
            headers: headers,
            responseType: responseType
        )
    }
    
    class func delete<T: Decodable>(
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        responseType: T.Type
    ) async throws -> T {
        try await NetworkManager.shared.request(
            method: .DELETE,
            path: path,
            parameters: parameters,
            isTokenRequired: isTokenRequired,
            headers: headers,
            responseType: responseType
        )
    }
}
