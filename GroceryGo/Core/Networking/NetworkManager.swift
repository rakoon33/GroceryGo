//
//  NetworkManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private func completeOnMain<T, E: Error>(
        _ result: Result<T, E>,
        completion: @escaping (Result<T, E>) -> Void
    ) {
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    // MARK: - Mask sensitive info
    private func maskSensitiveInfo(_ dictionary: [String: Any]) -> [String: Any] {
        var masked = dictionary
        let sensitiveKeys = ["password", "token", "Authorization"]
        for key in sensitiveKeys {
            if masked.keys.contains(key) {
                masked[key] = "***"
            }
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
    
    // MARK: - Request
    func request(
        method: HTTPMethod,
        path: String,
        parameters: [String: Any]? = nil,
        isTokenRequired: Bool = false,
        headers: [String: String] = [:],
        completion: @escaping (Result<[String: Any], NetworkErrorType>) -> Void
    ) {
        // Chạy phần build URL và request body trên background thread
        // vì có thể tốn thời gian nếu parameters lớn hoặc encode nhiều dữ liệu
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // Dùng [weak self] để tránh retain cycle giữa closure và NetworkManager
            // guard let self = self else { return } đảm bảo self còn tồn tại trước khi sử dụng
            guard let self = self else { return }
            
            var finalURL: URL?
            
            if method == .GET, let parameters = parameters {
                var components = URLComponents(string: path)
                components?.queryItems = parameters.map {
                    URLQueryItem(name: $0.key, value: "\($0.value)")
                }
                finalURL = components?.url
            } else {
                finalURL = URL(string: path)
            }
            
            guard let url = finalURL else {
                completeOnMain(.failure(.invalidURL), completion: completion)
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }
            
            if isTokenRequired {
                let token = AuthManager.shared.token
                if token.isEmpty {
                    self.completeOnMain(.failure(.unauthorized), completion: completion)
                    return
                }
                request.setValue(token, forHTTPHeaderField: APIHeader.tokenHeader)
            }
            
            if method != .GET, let parameters = parameters {
                let formBody = parameters.map {
                    "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                }.joined(separator: "&")
                request.httpBody = formBody.data(using: .utf8)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
            
            logRequest(request, parameters: parameters)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                self.logResponse(data: data, response: response, error: error)
                
                // 1. network error
                if let error = error as? URLError {
                    let networkError: NetworkErrorType
                    switch error.code {
                    case .notConnectedToInternet:
                        networkError = .noInternet
                    case .networkConnectionLost:
                        networkError = .networkLost
                    case .timedOut:
                        networkError = .timeout
                    default:
                        networkError = .unknown(
                            code: error.errorCode,
                            message: error.localizedDescription
                        )
                    }
                    self.completeOnMain(.failure(networkError), completion: completion)
                    return
                }
                
                // 2. no data
                guard let data = data else {
                    self.completeOnMain(.failure(.noData), completion: completion)
                    return
                }
                
                // 3. check status code
                if let httpResponse = response as? HTTPURLResponse {
                    let statusCode = httpResponse.statusCode
                    if statusCode >= 400 {
                        // Parse message từ JSON nếu có
                        var serverMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let msg = json[KKey.message] as? String {
                            serverMessage = msg
                        }
                        
                        let errorType = NetworkErrorType(code: statusCode, message: serverMessage)
                        self.completeOnMain(.failure(errorType), completion: completion)
                        return
                    }
                }
                
                // 4. Parse JSON into dictionary
                do {
                    let jsonObj = try JSONSerialization.jsonObject(with: data)

                    // Chỉ chấp nhận dictionary
                    guard let json = jsonObj as? [String: Any] else {
                        let message = "Expected JSON dictionary but got \(type(of: jsonObj))"
                        self.completeOnMain(.failure(.decodingError(message: message)), completion: completion)
                        return
                    }

                    // Check server code
                    if let serverCode = json[KKey.code] as? Int ?? Int(json[KKey.code] as? String ?? "") {
                        if serverCode == APISuccessCode.success {
                            self.completeOnMain(.success(json), completion: completion)
                        } else {
                            let message = json[KKey.message] as? String ?? "Unknown server error"
                            self.completeOnMain(.failure(.unknown(code: serverCode, message: message)), completion: completion)
                        }
                    } else {
                        self.completeOnMain(.failure(.decodingError(message: "Missing 'code' in server response")), completion: completion)
                    }

                } catch {
                    // Nếu JSONSerialization throw
                    self.completeOnMain(.failure(.decodingError(message: error.localizedDescription)), completion: completion)
                }

                
                
            }.resume()
        }
    }
}
