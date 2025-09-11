//
//  CartResponse.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//


import Foundation

/// Response cho API Cart
struct CartResponse: Decodable {
    let payload: [CartItemModel]
    let total: Double
    let deliverPriceAmount: Double
    let discountAmount: Double
    let userPayPrice: Double
    let message: String?
    let code: Int
    
    enum CodingKeys: String, CodingKey {
        case payload
        case total
        case deliverPriceAmount = "deliver_price_amount"
        case discountAmount = "discount_amount"
        case userPayPrice = "user_pay_price"
        case message = "message"
        case code = "status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.code = try container.decodeInt(forKey: .code)
        
        // payload (danh sách sản phẩm trong giỏ)
        self.payload = (try? container.decode([CartItemModel].self, forKey: .payload)) ?? []
        
        // các field numeric
        self.total = try container.decodeDouble(forKey: .total)
        self.deliverPriceAmount = try container.decodeDouble(forKey: .deliverPriceAmount)
        self.discountAmount = try container.decodeDouble(forKey: .discountAmount)
        self.userPayPrice = try container.decodeDouble(forKey: .userPayPrice)
        
        // message optional
        self.message = try? container.decode(String.self, forKey: .message)
    }
}
