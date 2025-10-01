//
//  PaymentModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/9/25.
//

import Foundation
import SwiftUI


struct PaymentModel: Codable, Identifiable, Equatable {
    
    let id: Int
    let name: String
    let cardNumber: String
    let cardMonth: String
    let cardYear: String
    
    
    enum CodingKeys: String, CodingKey {
        case id = "pay_id"
        case name = "name"
        case cardNumber = "card_number"
        case cardMonth = "card_month"
        case cardYear = "card_year"
    }
    
    init(id: Int = 0, name: String = "", cardNumber: String = "",  cardMonth: String = "",  cardYear: String = "") {
        self.id = id
        self.name = name
        self.cardNumber = cardNumber
        self.cardMonth = cardMonth
        self.cardYear = cardYear
    }
    
    static func == (lhs: PaymentModel, rhs: PaymentModel) -> Bool {
        lhs.id == rhs.id
    }
}
