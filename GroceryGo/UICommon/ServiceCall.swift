//
//  ServiceCall.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 8/8/25.
//

import SwiftUI

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

final class ServiceCall {
    
    class func post(parameter: [String: Any], path: String, isToken: Bool = false, withSuccess: @escaping (AnyObject?) -> (), failure: @escaping (Error?) -> ()) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            // Convert dictionary -> x-www-form-urlencoded
            let formBody = parameter.map { (key, value) in
                "\(key)=\(String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            }.joined(separator: "&")
            
            guard let url = URL(string: path),
                  let postData = formBody.data(using: .utf8) else {
                DispatchQueue.main.async {
                    failure(nil)
                }
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = postData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                    return
                }
                
                guard let data = data else {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
                    DispatchQueue.main.async {
                        withSuccess(json)
                    }
                } catch {
                    DispatchQueue.main.async {
                        failure(error)
                    }
                }
            }
            
            task.resume()
        }
    }
}

