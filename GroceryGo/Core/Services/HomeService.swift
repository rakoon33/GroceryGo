//
//  HomeService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//
import Foundation
import SwiftUI

protocol HomeServiceProtocol {
    func fetchHomeData(
        completion: @escaping (Result<(offers: [ProductModel], bests: [ProductModel], list: [ProductModel], types: [TypeModel]), NetworkErrorType>) -> Void
    )
}

final class HomeService: HomeServiceProtocol {
    func fetchHomeData(
        completion: @escaping (Result<(offers: [ProductModel], bests: [ProductModel], list: [ProductModel], types: [TypeModel]), NetworkErrorType>) -> Void
    ) {
        ServiceCall.post(
            parameter: [:],
            isTokenRequired: true,
            path: Globs.SV_HOME

        ) { json in
            guard let response = json else {
                completion(.failure(.noData))
                return
            }
            
            do {
                guard let payload = response[KKey.payload] as? [String: Any] else {
                    completion(.failure(.unknown(code: -1, message: "fail_message")))
                    return
                }
                
                let decoder = JSONDecoder()
                
                let offersData = try JSONSerialization.data(withJSONObject: payload["offer_list"] ?? [])
                let bestsData  = try JSONSerialization.data(withJSONObject: payload["best_sell_list"] ?? [])
                let listData   = try JSONSerialization.data(withJSONObject: payload["list"] ?? [])
                let typesData  = try JSONSerialization.data(withJSONObject: payload["type_list"] ?? [])
                
                let offers = try decoder.decode([ProductModel].self, from: offersData)
                let bests  = try decoder.decode([ProductModel].self, from: bestsData)
                let list   = try decoder.decode([ProductModel].self, from: listData)
                let types  = try decoder.decode([TypeModel].self, from: typesData)
                
                completion(.success((offers, bests, list, types)))
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
