//
//  ImageModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import Foundation
import SwiftUI


struct ImageModel: Codable, Identifiable, Equatable {
    let id: Int
    let prodId: Int
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "img_id"
        case prodId = "prod_id"
        case image = "image"
    }
    
    init(id: Int = 0, prod_id: Int = 0, image: String = "") {
           self.id = id
           self.prodId = prod_id
           self.image = image
       }
    
    static func == (lhs: ImageModel, rhs: ImageModel) -> Bool {
        lhs.id == rhs.id
    }
}
