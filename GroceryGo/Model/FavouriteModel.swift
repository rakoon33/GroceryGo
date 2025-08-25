//
//  FavouriteModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 23/8/25.
//

import Foundation
import SwiftUI


struct FavouriteModel: Codable, Identifiable, Equatable {
    let id: Int              
    let product: ProductModel
    
    enum CodingKeys: String, CodingKey {
        case id = "fav_id"
    }
    
    init(from decoder: Decoder) throws {
        // lấy fav_id riêng
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeInt(forKey: .id)
        // còn lại map sang ProductModel
        product = try ProductModel(from: decoder)
    }
    
    // Custom init 
    init(id: Int = 0, product: ProductModel = ProductModel()) {
        self.id = id
        self.product = product
    }
    
    
    static func == (lhs: FavouriteModel, rhs: FavouriteModel) -> Bool {
        lhs.id == rhs.id
    }
}
