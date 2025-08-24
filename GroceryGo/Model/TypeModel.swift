//
//  TypeModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//

import Foundation
import SwiftUI


struct TypeModel: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let image: String
    let colorHex: String
    
    var color: Color {
        Color(hex: colorHex)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "type_id"
        case name = "type_name"
        case image = "image"
        case colorHex = "color"
    }
    
    init(id: Int = 0, name: String = "", image: String = "", colorHex: String = "#FFFFFF") {
           self.id = id
           self.name = name
           self.image = image
           self.colorHex = colorHex
       }
    
    static func == (lhs: TypeModel, rhs: TypeModel) -> Bool {
        lhs.id == rhs.id
    }
}
