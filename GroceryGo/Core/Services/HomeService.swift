//
//  HomeService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//
import Foundation
import SwiftUI

struct HomePayload: Codable {
    let offer_list: [ProductModel]
    let best_sell_list: [ProductModel]
    let list: [ProductModel]
    let type_list: [TypeModel]
}

protocol HomeServiceProtocol {
    func fetchHomeData() async throws -> (offers: [ProductModel], bests: [ProductModel], list: [ProductModel], types: [TypeModel])
}

final class HomeService: HomeServiceProtocol {
    
    func fetchHomeData() async throws -> (offers: [ProductModel],
                                          bests: [ProductModel],
                                          list: [ProductModel],
                                          types: [TypeModel]) {
        

        let payload: HomePayload = try await ServiceCall.post(
            path: Globs.SV_HOME,
            parameters: [:],
            isTokenRequired: true,
            responseType: HomePayload.self
        )
        
        return (payload.offer_list,
                payload.best_sell_list,
                payload.list,
                payload.type_list)
    }
}
