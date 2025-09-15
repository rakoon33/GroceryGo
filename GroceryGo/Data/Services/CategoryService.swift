//
//  ExploreService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import Foundation

protocol CategoryServiceProtocol {
    func fetchExploreList() async throws -> [CategoryModel]
    func fetchExploreCategoryItem(catId: Int) async throws -> [ProductModel]
}


final class CategoryService: CategoryServiceProtocol {
    
    func fetchExploreList() async throws -> [CategoryModel] {
        try await ServiceCall.post(
            path: Globs.SV_EXPLORE_LIST,
            parameters: [:],
            isTokenRequired: true,
            responseType: [CategoryModel].self
        )
    }
    
    func fetchExploreCategoryItem(catId: Int) async throws -> [ProductModel] {
        try await ServiceCall.post(
            path: Globs.SV_EXPLORE_ITEM_LIST,
            parameters: ["cat_id": catId],
            isTokenRequired: true,
            responseType: [ProductModel].self
        )
    }
}
