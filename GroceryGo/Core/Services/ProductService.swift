//
//  ProductService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//

import Foundation


protocol ProductServiceProtocol {
    func fetchProductDetail(
        prod_id: Int,
        completion: @escaping (Result<(product: ProductModel, nutritions: [NutritionModel], images: [ImageModel]) , NetworkErrorType>) -> Void
    )
}

final class ProductService: ProductServiceProtocol {
    func fetchProductDetail(
        prod_id: Int,
        completion: @escaping (Result<(product: ProductModel, nutritions: [NutritionModel], images: [ImageModel]), NetworkErrorType>) -> Void
    ) {
        ServiceCall.post(
            parameter: ["prod_id": prod_id,],
            isTokenRequired: true,
            path: Globs.SV_PRODUCT_DETAIL
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
                
                // 1. Decode product
                let productData = try JSONSerialization.data(withJSONObject: payload)
                let product = try decoder.decode(ProductModel.self, from: productData)
                
                // 2. Decode nutritions
                let nutritionsData = try JSONSerialization.data(withJSONObject: payload["nutrition_list"] ?? [])
                let nutritions = try decoder.decode([NutritionModel].self, from: nutritionsData)
                
                // 3. Decode images
                let imagesData = try JSONSerialization.data(withJSONObject: payload["images"] ?? [])
                let images = try decoder.decode([ImageModel].self, from: imagesData)
                
                completion(.success((product: product, nutritions: nutritions, images: images)))
                
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
