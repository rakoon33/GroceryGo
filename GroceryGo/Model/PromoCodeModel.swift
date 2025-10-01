//
//  PromoCodeModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/9/25.
//

import Foundation

struct PromoCodeModel: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let type: Int
    
    let title: String
    let code: String
    let description: String
    let startDate: Date?
    let endDate: Date?
    let minOrderAmount: Double
    let maxDiscountAmount: Double
    let offerPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "promo_code_id"
        case type = "type"
        case title = "title"
        case code = "code"
        case description = "description"
        case startDate = "start_date"
        case endDate = "end_date"
        case minOrderAmount = "min_order_amount"
        case maxDiscountAmount = "max_discount_amount"
        case offerPrice = "offer_price"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id                = try container.decodeInt(forKey: .id)
        type              = try container.decodeInt(forKey: .type)
        title             = (try? container.decode(String.self, forKey: .title)) ?? ""
        code              = (try? container.decode(String.self, forKey: .code)) ?? ""
        description       = (try? container.decode(String.self, forKey: .description)) ?? ""
        startDate         = try? container.decodeDate(forKey: .startDate)
        endDate           = try? container.decodeDate(forKey: .endDate)
        minOrderAmount    = try container.decodeDouble(forKey: .minOrderAmount)
        maxDiscountAmount = try container.decodeDouble(forKey: .maxDiscountAmount)
        offerPrice        = try container.decodeDouble(forKey: .offerPrice)      
    }
    
    init(
        id: Int = 0,
        type: Int = 0,
        title: String = "",
        code: String = "",
        description: String = "",
        startDate: Date? = nil,
        endDate: Date? = nil,
        minOrderAmount: Double = 0.0,
        maxDiscountAmount: Double = 0.0,
        offerPrice: Double = 0.0
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.code = code
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.minOrderAmount = minOrderAmount
        self.maxDiscountAmount = maxDiscountAmount
        self.offerPrice = offerPrice
    }
    
    static func == (lhs: PromoCodeModel, rhs: PromoCodeModel) -> Bool {
        lhs.id == rhs.id
    }
}
