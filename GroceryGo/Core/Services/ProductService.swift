//
//  ProductService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//

import Foundation


protocol ProductServiceProtocol {
    func fetchProductDetail(prodId: Int) async throws -> (product: ProductModel, nutritions: [NutritionModel], images: [ImageModel])
}

final class ProductService: ProductServiceProtocol {
    
    func fetchProductDetail(prodId: Int) async throws -> (product: ProductModel, nutritions: [NutritionModel], images: [ImageModel]) {
        
        struct ProductDetailPayload: Codable {
            let product: ProductModel
            let nutritionList: [NutritionModel]
            let images: [ImageModel]
            
            enum CodingKeys: String, CodingKey {
                case nutritionList = "nutrition_list"
                case images
            }
            
            init(from decoder: Decoder) throws {
                // 1. Decode product bằng luôn ProductModel (toàn bộ payload)
                self.product = try ProductModel(from: decoder)
                
                // 2. Decode nutrition_list + images
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.nutritionList = try container.decodeIfPresent([NutritionModel].self, forKey: .nutritionList) ?? []
                self.images = try container.decodeIfPresent([ImageModel].self, forKey: .images) ?? []
            }
        }

        
        let payload: ProductDetailPayload = try await ServiceCall.post(
            path: Globs.SV_PRODUCT_DETAIL,
            parameters: ["prod_id": prodId],
            isTokenRequired: true,
            responseType: ProductDetailPayload.self
        )
        
        return (product: payload.product,
                nutritions: payload.nutritionList,
                images: payload.images)
    }
}
