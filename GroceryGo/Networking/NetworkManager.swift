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
        headers: [String: String] = [:],
        completion: @escaping (Result<[String: Any], NetworkErrorType>) -> Void
    ) {
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
            
            // 1. Lỗi kết nối mạng
            if let error = error as? URLError {
                let networkError: NetworkErrorType
                switch error.code {
                case .notConnectedToInternet, .networkConnectionLost:
                    networkError = .networkLost
                case .timedOut:
                    networkError = .timeout
                default:
                    networkError = .serverError(
                        code: error.errorCode,
                        message: error.localizedDescription,
                        data: nil
                    )
                }
                self.completeOnMain(.failure(networkError), completion: completion)
                return
            }
            
            // 2. Không có data
            guard let data = data else {
                self.completeOnMain(.failure(.noData), completion: completion)
                return
            }
            
            // 3. Kiểm tra status code
            if let httpResponse = response as? HTTPURLResponse {
                let statusCode = httpResponse.statusCode
                if statusCode >= 400 {
                    // Thử parse JSON để lấy message từ server
                    var serverMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                    var jsonData: Any? = nil
                    
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        jsonData = json
                        if let msg = json[KKey.message] as? String {
                            serverMessage = msg
                        }
                    }
                    
                    let errorType: NetworkErrorType
                    switch statusCode {
                    case NetworkErrorCode.unauthorized:
                        errorType = .unauthorized
                    case NetworkErrorCode.forbidden:
                        errorType = .forbidden
                    case NetworkErrorCode.notFound:
                        errorType = .notFound
                    case NetworkErrorCode.verificationExpired:
                        errorType = .verificationExpired
                    default:
                        errorType = .serverError(code: statusCode, message: serverMessage, data: jsonData)
                    }
                    
                    self.completeOnMain(.failure(errorType), completion: completion)
                    return
                }
            }
            
            // 4. Parse JSON thành dictionary
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    self.completeOnMain(.success(json), completion: completion)
                } else {
                    self.completeOnMain(.failure(.decodingError), completion: completion)
                }
            } catch {
                self.completeOnMain(.failure(.decodingError), completion: completion)
            }

            
        }.resume()
    }
}
