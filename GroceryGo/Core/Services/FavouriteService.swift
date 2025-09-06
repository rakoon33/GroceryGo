//
//  FavouriteService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 23/8/25.
//

import Foundation


protocol FavouriteServiceProtocol {
    func fetchFavouriteList() async throws -> [FavouriteModel]
    func addOrRemoveFavourite(prodId: Int) async throws
}

final class FavouriteService: FavouriteServiceProtocol {
    
    func fetchFavouriteList() async throws -> [FavouriteModel] {
        try await ServiceCall.post(
            path: Globs.SV_FAVOURITE_LIST,
            parameters: [:],
            isTokenRequired: true,
            responseType: [FavouriteModel].self
        )
    }
    
    func addOrRemoveFavourite(prodId: Int) async throws {
        let params = ["prod_id": prodId]
        
        // Vì API không trả payload cụ thể, chỉ cần gọi thành công là xong
        let _: EmptyPayload = try await ServiceCall.post(
            path: Globs.SV_ADD_REMOVE_FAVOURITE,
            parameters: params,
            isTokenRequired: true,
            responseType: EmptyPayload.self
        )
    }
}
