//
//  NetworkManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//

import Foundation

enum HTTPMethod: String { case GET, POST, PUT, DELETE }

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    // MARK: - Mask sensitive info
    private func maskSensitiveInfo(_ dictionary: [String: Any]) -> [String: Any] {
        var masked = dictionary
        let sensitiveKeys = ["password", "token", "Authorization"]
        for key in sensitiveKeys where masked.keys.contains(key) {
            masked[key] = "***"
        }
        return masked
    }
    
    // MARK: - Logging
    private func logRequest(_ request: URLRequest, parameters: [String: Any]?) {
        print("----- [REQUEST] -----")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        print("Headers: \(maskSensitiveInfo(request.allHTTPHeaderFields ?? [:]))")
        if let parameters = parameters {
            print("Parameters: \(maskSensitiveInfo(parameters))")
        }
        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            if let jsonData = bodyString.data(using: .utf8),
               let jsonObj = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                print("Body: \(maskSensitiveInfo(jsonObj))")
            } else {
                print("Body: \(bodyString)")
            }
        }
        print("---------------------")
    }
    
    private func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        print("----- [RESPONSE] -----")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(maskSensitiveInfo(httpResponse.allHeaderFields as? [String: Any] ?? [:]))")
        }
        if let error = error {
            print("Error: \(error.localizedDescription)")
        }
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            print("Body: \(maskSensitiveInfo(json))")
        } else if let data = data,
                  let bodyString = String(data: data, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
        print("----------------------")
    }
    
    // MARK: - Request (Generic)
    func request<T: Decodable>(
        method: HTTPMethod,
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
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
        }
        
        if method != .GET {
            if let parameters = parameters {
                let formBody = parameters.map {
                    "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                }.joined(separator: "&")
                request.httpBody = formBody.data(using: .utf8)
            } else {
                request.httpBody = Data() // POST rỗng, body empty
            }
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        }
        
        
        // Log request
        logRequest(request, parameters: parameters)
        
        // Execute
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Log response
            logResponse(data: data, response: response, error: nil)
            
            // Map HTTP errors
            if let http = response as? HTTPURLResponse, http.statusCode >= 400 {
                // fallback mặc định
                var serverMessage = HTTPURLResponse.localizedString(forStatusCode: http.statusCode)
                
                if let decoded = try? JSONDecoder().decode(APIResponse<EmptyPayload>.self, from: data),
                   let msg = decoded.message {
                    serverMessage = msg
                }
                

                if http.statusCode == 401 {// unauthorized, thuong nen refresh_token
                    await SessionManager.shared.logout()
                    throw NetworkErrorType.unauthorized
                }
                
                throw NetworkErrorType(code: http.statusCode, message: serverMessage)
            }
            // Decode server wrapper (code + payload)
            let wrapper = try JSONDecoder().decode(APIResponse<T>.self, from: data)
            
            if wrapper.code == APISuccessCode.success {
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
}
