//
//  ExploreCategoryViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import Foundation
import SwiftUI


struct CategoryModel: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let image: String
    let colorHex: String
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "cat_id"
        case name = "cat_name"
        case image = "image"
        case colorHex = "color"
    }
    
    init(id: Int = 0, name: String = "", image: String = "", colorHex: String = "#FFFFFF") {
           self.id = id
           self.name = name
           self.image = image
           self.colorHex = colorHex
    }
    
    static func == (lhs: CategoryModel, rhs: CategoryModel) -> Bool {
        lhs.id == rhs.id
    }
}
