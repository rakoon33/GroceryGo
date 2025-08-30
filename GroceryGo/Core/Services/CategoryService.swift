//
//  ExploreService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import Foundation

protocol CategoryServiceProtocol {
    
    func fetchExploreList(
        completion: @escaping (Result<[CategoryModel], NetworkErrorType>) -> Void
    )
    
    func fetchExploreCategoryItem(
        catId: Int,
        completion: @escaping (Result<[ProductModel], NetworkErrorType>) -> Void
    )
}


final class CategoryService: CategoryServiceProtocol {
    
    func fetchExploreList(
        completion: @escaping (Result<[CategoryModel], NetworkErrorType>) -> Void
    ) {
        ServiceCall.post(
            parameter: [:], // nếu API không cần param thì để trống
            isTokenRequired: true,
            path: Globs.SV_EXPLORE_LIST
        ) { response in
            guard let response = response,
                  let serverCode = (response[KKey.code] as? Int) ??
                    Int(response[KKey.code] as? String ?? ""),
                  serverCode == APISuccessCode.success,
                  let payload = response[KKey.payload] as? [[String: Any]] else {
                completion(.failure(.unknown(code: -1, message: "fail_message")))
                return
            }
            
            do {
                let data = try JSONSerialization.data(withJSONObject: payload)
                let categoryList = try JSONDecoder().decode([CategoryModel].self, from: data)
                completion(.success(categoryList))
            } catch let decodingError as DecodingError {
                completion(.failure(.decodingError(message: decodingError.detailedMessage)))
            } catch {
                completion(.failure(.unknown(code: -1, message: error.localizedDescription)))
            }
        } failure: { netError in
            completion(.failure(netError))
        }
    }
    
    func fetchExploreCategoryItem(
        catId: Int,
        completion: @escaping (Result<[ProductModel], NetworkErrorType>) -> Void
    ) {
        let params = ["cat_id": catId]
        
        ServiceCall.post(parameter: params, isTokenRequired: true, path: Globs.SV_EXPLORE_ITEM_LIST) { json in
            
            guard let response = json else {
                completion(.failure(.noData))
                return
            }
            
            do {
                
                guard let payload = response[KKey.payload] as? [[String: Any]] else {
                    completion(.failure(.unknown(code: -1, message: "fail_message")))
                    return
                }
                
                let decoder = JSONDecoder()
                
                // 1. Decode product
                let productData = try JSONSerialization.data(withJSONObject: payload)
                let products = try decoder.decode([ProductModel].self, from: productData)
                
                
                completion(.success(products))
                
            } catch let decodingError as DecodingError {
                completion(.failure(.decodingError(message: decodingError.detailedMessage)))
            } catch {
                completion(.failure(.unknown(code: -1, message: "fail_message")))
            }
        } failure: { error in
            completion(.failure(error))
        }
    }
}


