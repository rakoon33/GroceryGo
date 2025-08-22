//
//  NutritionModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import Foundation
import SwiftUI


struct NutritionModel: Codable, Identifiable, Equatable {
    let id: Int
    let nutritionName: String
    let nutritionValue: String
    
    enum CodingKeys: String, CodingKey {
        case id = "nutrition_id"
        case nutritionName = "nutrition_name"
        case nutritionValue = "nutrition_value"
    }
    
    init(id: Int = 0, nutritionName: String = "", nutritionValue: String = "") {
           self.id = id
           self.nutritionName = nutritionName
           self.nutritionValue = nutritionValue
       }
    
    static func == (lhs: NutritionModel, rhs: NutritionModel) -> Bool {
        lhs.id == rhs.id
    }
}
