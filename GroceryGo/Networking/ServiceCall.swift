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
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .POST, path: path, parameters: parameter) { result in
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
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .PUT, path: path, parameters: parameter) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }

    class func delete(
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .DELETE, path: path, parameters: nil) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }

    class func get(
        path: String,
        withSuccess: @escaping ([String: Any]?) -> (),
        failure: @escaping (NetworkErrorType) -> ()
    ) {
        NetworkManager.shared.request(method: .GET, path: path, parameters: nil) { result in
            switch result {
            case .success(let json):
                withSuccess(json)
            case .failure(let error):
                failure(error)
            }
        }
    }
}


//final class ServiceCall {
//    
//    class func post(parameter: [String: Any], path: String, isToken: Bool = false, withSuccess: @escaping ([String: Any]?) -> (), failure: @escaping (Error?) -> ()) {
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            
//            // Convert dictionary -> x-www-form-urlencoded
//            let formBody = parameter.map { (key, value) in
//                "\(key)=\(String(describing: value).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
//            }.joined(separator: "&")
//            
//            guard let url = URL(string: path),
//                  let postData = formBody.data(using: .utf8) else {
//                DispatchQueue.main.async {
//                    failure(nil)
//                }
//                return
//            }
//            
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//            request.httpBody = postData
//            
//            let task = URLSession.shared.dataTask(with: request) { data, response, error in
//                if let error = error {
//                    DispatchQueue.main.async {
//                        failure(error)
//                    }
//                    return
//                }
//                
//                guard let data = data else {
//                    
//                    DispatchQueue.main.async {
//                        failure(error)
//                    }
//                    
//                    return
//                }
//                
//                do {
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                    
//                    if let json = json {
//                        debugPrint("response:", json)
//                        DispatchQueue.main.async {
//                            withSuccess(json)
//                        }
//                    } else {
//                        DispatchQueue.main.async {
//                            failure(NSError(domain: "Invalid JSON format", code: -1))
//                        }
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        failure(error)
//                    }
//                }
//            }
//            
//            task.resume()
//        }
//    }
//}
//
