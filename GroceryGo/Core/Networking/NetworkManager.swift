//
//  NetworkManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//

import Foundation

enum HTTPMethod: String { case GET, POST, PUT, DELETE }

enum ContentType: String {
    case json       = "application/json"
    case form       = "application/x-www-form-urlencoded"
    case multipart  = "multipart/form-data"
}

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let config: NetworkConfig
    
    private init(config: NetworkConfig = .default) {
        self.config = config
        
        // Tạo bản sao của sessionType để chỉnh sửa
        // Lý do: .default, .ephemeral, .background là shared instance hệ thống.
        // Nếu chỉnh trực tiếp sẽ ảnh hưởng tất cả session khác dùng cùng instance.
        // copy() tạo instance riêng, an toàn để chỉnh timeout, headers, waitsForConnectivit
        let configuration = config.sessionType.copy() as! URLSessionConfiguration
        configuration.timeoutIntervalForRequest = config.requestTimeout
        configuration.timeoutIntervalForResource = config.resourceTimeout
        configuration.waitsForConnectivity = config.waitsForConnectivity
        configuration.httpAdditionalHeaders = config.defaultHeaders
        
        self.session = URLSession(configuration: configuration)
    }
    
    private func logRequest(_ request: URLRequest, parameters: [String: Any]?) {
        AppLogger.logRequest(request, parameters: parameters)
    }
    
    private func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        AppLogger.logResponse(response, data: data, error: error)
    }
    
    // MARK: - Request (Generic)
    func request<T: Decodable>(
        method: HTTPMethod,
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        contentType: ContentType = .form,
        responseType: T.Type
    ) async throws -> T {
        
        // Build URL
        var finalURL: URL?
        if method == .GET, let parameters = parameters {
            var components = URLComponents(string: path)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            finalURL = components?.url
        } else {
            finalURL = URL(string: path)
        }
        guard let url = finalURL else { throw NetworkErrorType.invalidURL }
        
        // Build request
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if isTokenRequired {
            let token = await SessionManager.shared.token
            
            guard !token.isEmpty else {
                throw NetworkErrorType.unauthorized
            }
            request.setValue(token, forHTTPHeaderField: APIHeader.tokenHeader)
            
//            request.setValue("Bearer \(token)", forHTTPHeaderField: APIHeader.tokenHeader)
        }
        
        if method != .GET {
            if let parameters = parameters {
                switch contentType {
                case .form:
                    let formBody = parameters.map {
                        "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                    }.joined(separator: "&")
                    request.httpBody = formBody.data(using: .utf8)
                    
                case .json:
                    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
                    
                case .multipart:
                    // Multipart upload: cần implement riêng
                    break
                }
            }
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        // Log request
        logRequest(request, parameters: parameters)
        
        // Execute
        do {
            let (data, response) = try await session.data(for: request)

            // Log response
            logResponse(data: data, response: response, error: nil)
            
            // Map HTTP errors
            if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
                
                if http.statusCode == 401 {
                    // unauthorized, thuong nen refresh_token nêu refresh vân k đc throw unauthorized
                    throw NetworkErrorType.unauthorized
                    
                }
                
                var serverMessage = HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
                
                if let decoded = try? JSONDecoder().decode(APIResponse<EmptyPayload>.self, from: data),
                   let msg = decoded.message {
                    serverMessage = msg
                }
                
                throw NetworkErrorType(code: http.statusCode, message: serverMessage)
            }
            
            // Decode server wrapper (code + payload)
            let wrapper = try JSONDecoder().decode(APIResponse<T>.self, from: data)
            
            if wrapper.code == APISuccessCode.success {
                if T.self is EmptyPayload.Type {
                    return EmptyPayload() as! T
                }
                guard let payload = wrapper.payload else {
                    throw NetworkErrorType.decodingError(message: "Missing payload")
                }
                return payload
            } else {
                throw NetworkErrorType.unknown(code: wrapper.code,
                                               message: wrapper.message ?? "Unknown server error")
            }
            
        } catch let urlErr as URLError {
            logResponse(data: nil, response: nil, error: urlErr)
            switch urlErr.code {
            case .notConnectedToInternet: throw NetworkErrorType.noInternet
            case .networkConnectionLost:  throw NetworkErrorType.networkLost
            case .timedOut:               throw NetworkErrorType.timeout
            default:
                throw NetworkErrorType.unknown(code: urlErr.errorCode, message: urlErr.localizedDescription)
            }
        } catch let e as DecodingError {
            logResponse(data: nil, response: nil, error: e)
            throw NetworkErrorType.decodingError(message: e.detailedMessage)
        } catch {
            logResponse(data: nil, response: nil, error: error)
            throw error
        }
    }
    
    func requestRaw<T: Decodable>( // for api json not the same as APIResponse
        method: HTTPMethod,
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        contentType: ContentType = .form,
        responseType: T.Type
    ) async throws -> T {
        
        // Build URL and request
        var finalURL: URL?
        if method == .GET, let parameters = parameters {
            var components = URLComponents(string: path)
            components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
            finalURL = components?.url
        } else {
            finalURL = URL(string: path)
        }
        guard let url = finalURL else { throw NetworkErrorType.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
        
        if isTokenRequired {
            
            let token = await SessionManager.shared.token
            
            guard !token.isEmpty else { throw NetworkErrorType.unauthorized }
            request.setValue(token, forHTTPHeaderField: APIHeader.tokenHeader)
        }
        
        if method != .GET, let parameters = parameters {
            switch contentType {
            case .form:
                let formBody = parameters.map {
                    "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                }.joined(separator: "&")
                request.httpBody = formBody.data(using: .utf8)
            case .json:
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            case .multipart:
                break
            }
            request.setValue(contentType.rawValue, forHTTPHeaderField: "Content-Type")
        }
        
        logRequest(request, parameters: parameters)
        
        do {
            let (data, response) = try await session.data(for: request)
            logResponse(data: data, response: response, error: nil)
            
            if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
                throw NetworkErrorType(code: http.statusCode, message: HTTPURLResponse.localizedString(forStatusCode: http.statusCode))
            }
            
            // Decode directly into T (custom type)
            return try JSONDecoder().decode(T.self, from: data)
            
        } catch let urlErr as URLError {
            logResponse(data: nil, response: nil, error: urlErr)
            throw urlErr
        } catch {
            logResponse(data: nil, response: nil, error: error)
            throw error
        }
    }

}
