//
//  CartItemModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//

import Foundation

struct CartItemModel: Codable, Identifiable, Equatable {
    let id: Int
    
    let prodId: Int
    let userId: Int
    let qty: Int
    
    let catId: Int
    let brandId: Int
    let typeId: Int
    
    let name: String
    let detail: String
    let unitName: String
    let unitValue: String
    let nutritionWeight: String
    
    let brandName: String?
    
    var offerPrice: Double?
    let startDate: Date?
    let endDate: Date?
    
    let price: Double
    var image: String
    
    let catName: String
    let typeName: String
    
    let itemPrice: Double?
    let totalPrice: Double?
    
    let isFav: Bool
    let avgRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "cart_id"
        
        case prodId = "prod_id"
        case userId = "user_id"
        case qty = "qty"
        
        case catId = "cat_id"
        case brandId = "brand_id"
        case typeId = "type_id"
        
        case brandName = "brand_name"
        case catName = "cat_name"
        case typeName = "type_name"
        
        case name = "name"
        case detail = "detail"
        case unitName = "unit_name"
        case unitValue = "unit_value"
        case nutritionWeight = "nutrition_weight"
        
        case offerPrice = "offer_price"
        case startDate = "start_date"
        case endDate = "end_date"
        case price = "price"
        case image = "image"
        
        case itemPrice = "item_price"
        case totalPrice = "total_price"
        
        case isFav = "is_fav"
        case avgRating = "avg_rating"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id              = try container.decodeInt(forKey: .id)
        
        prodId          = try container.decodeInt(forKey: .prodId)
        userId          = try container.decodeInt(forKey: .userId)
        qty             = try container.decodeInt(forKey: .qty)
        
        catId           = try container.decodeInt(forKey: .catId)
        brandId         = try container.decodeInt(forKey: .brandId)
        typeId          = try container.decodeInt(forKey: .typeId)
        
        brandName       = (try? container.decode(String.self, forKey: .brandName)) ?? ""
        
        name            = try container.decodeString(forKey: .name)
        detail          = (try? container.decodeString(forKey: .detail)) ?? ""
        unitName        = (try? container.decodeString(forKey: .unitName)) ?? ""
        unitValue       = (try? container.decodeString(forKey: .unitValue)) ?? ""
        nutritionWeight = (try? container.decodeString(forKey: .nutritionWeight)) ?? ""
        
        offerPrice      = try? container.decodeDouble(forKey: .offerPrice)
        startDate       = try? container.decodeDate(forKey: .startDate)
        endDate         = try? container.decodeDate(forKey: .endDate)
        price           = try container.decodeDouble(forKey: .price)
        
        itemPrice       = try container.decode(Double.self, forKey: .itemPrice)
        totalPrice      = try container.decode(Double.self, forKey: .totalPrice)
        
        image           = (try? container.decodeString(forKey: .image)) ?? ""
        catName         = (try? container.decodeString(forKey: .catName)) ?? ""
        typeName        = (try? container.decodeString(forKey: .typeName)) ?? ""
        isFav           = (try? container.decodeInt(forKey: .isFav)) == 1
        avgRating       = (try? container.decodeDouble(forKey: .avgRating)) ?? 0.0
        
    }
    
    
    // MARK: - Custom Init
    init(
        id: Int = 0,
        
        prodId: Int = 0,
        userId:Int = 0,
        qty: Int = 0,
        
        catId: Int = 0,
        brandId: Int = 0,
        typeId: Int = 0,
        
        brandName: String = "",
        
        name: String = "",
        detail: String = "",
        unitName: String = "",
        unitValue: String = "",
        nutritionWeight: String = "",
        offerPrice: Double? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        price: Double = 0,
        
        itemPrice: Double = 0,
        totalPrice: Double = 0,
        
        image: String = "",
        catName: String = "",
        typeName: String = "",
        isFav: Bool = false,
        avgRating: Double = 0
    ) {
        self.id = id
        self.prodId = prodId
        self.userId = userId
        self.qty = qty
    
        self.catId = catId
        self.brandId = brandId
        self.typeId = typeId
        
        self.brandName = brandName
        
        self.name = name
        self.detail = detail
        self.unitName = unitName
        self.unitValue = unitValue
        self.nutritionWeight = nutritionWeight
        self.offerPrice = offerPrice
        self.startDate = startDate
        self.endDate = endDate
        self.price = price
        
        self.itemPrice = itemPrice
        self.totalPrice = totalPrice
        
        self.image = image
        self.catName = catName
        self.typeName = typeName
        self.isFav = isFav
        self.avgRating = avgRating
    }
    static func == (lhs: CartItemModel, rhs: CartItemModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.qty == rhs.qty &&
               lhs.totalPrice == rhs.totalPrice &&
               lhs.itemPrice == rhs.itemPrice
    }

}


extension CartItemModel {
    func toProductModel() -> ProductModel {
        ProductModel(
            id: prodId,
            catId: catId,
            brandId: brandId,
            typeId: typeId,
            name: name,
            detail: detail,
            unitName: unitName,
            unitValue: unitValue,
            nutritionWeight: nutritionWeight,
            offerPrice: offerPrice,
            startDate: startDate,
            endDate: endDate,
            price: price,
            image: image,
            catName: catName,
            typeName: typeName,
            isFav: isFav,
            avgRating: avgRating
        )
    }
}
