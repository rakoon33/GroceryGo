//
//  ExploreService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import Foundation

protocol ExploreServiceProtocol {
    
    func fetchExploreList(
        completion: @escaping (Result<[ExploreCategoryModel], NetworkErrorType>) -> Void
    )
    
    func addOrRemoveFavourite(
        prodId: Int,
        completion: @escaping (Result<Void, NetworkErrorType>) -> Void
    )
}


final class ExploreService: ExploreServiceProtocol {
    
    func fetchExploreList(
            completion: @escaping (Result<[ExploreCategoryModel], NetworkErrorType>) -> Void
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
                    let categoryList = try JSONDecoder().decode([ExploreCategoryModel].self, from: data)
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
        
    func addOrRemoveFavourite(
        prodId: Int,
        completion: @escaping (Result<Void, NetworkErrorType>) -> Void
    ) {
        let params = ["prod_id": prodId]
        
        ServiceCall.post(parameter: params, isTokenRequired: true, path: Globs.SV_ADD_REMOVE_FAVOURITE) { _ in
            completion(.success(()))
        } failure: { error in
            completion(.failure(error))
        }
    }
}
