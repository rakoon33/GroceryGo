//
//  ProductModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//


import Foundation

struct ProductModel: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let catId: Int
    let brandId: Int
    let typeId: Int
    
    let name: String
    let detail: String
    let unitName: String
    let unitValue: String
    let nutritionWeight: String
    
    
    var offerPrice: Double?
    let startDate: Date?
    let endDate: Date?
    
    let price: Double
    var image: String
    
    let catName: String
    let typeName: String
    
    let isFav: Bool
    let avgRating: Double
    
    enum CodingKeys: String, CodingKey {
        case id = "prod_id"
        case catId = "cat_id"
        case brandId = "brand_id"
        case typeId = "type_id"
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
        case catName = "cat_name"
        case typeName = "type_name"
        case isFav = "is_fav"
        case avgRating = "avg_rating"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id       = try container.decodeInt(forKey: .id)
        catId    = try container.decodeInt(forKey: .catId)
        brandId  = try container.decodeInt(forKey: .brandId)
        typeId   = try container.decodeInt(forKey: .typeId)
        
        name     = try container.decodeString(forKey: .name)
        detail   = try container.decodeString(forKey: .detail)
        unitName = try container.decodeString(forKey: .unitName)
        unitValue = try container.decodeString(forKey: .unitValue)
        nutritionWeight = try container.decodeString(forKey: .nutritionWeight)
        
        offerPrice = try? container.decodeDouble(forKey: .offerPrice) // optional
        startDate  = try? container.decodeDate(forKey: .startDate)
        endDate    = try? container.decodeDate(forKey: .endDate)
        price      = try container.decodeDouble(forKey: .price)
        
        image     = try container.decodeString(forKey: .image)
        catName   = try container.decodeString(forKey: .catName)
        typeName  = try container.decodeString(forKey: .typeName)
        isFav     = (try container.decodeInt(forKey: .isFav)) == 1
        avgRating = try container.decodeDouble(forKey: .avgRating)
    }

    
    // MARK: - Custom Init
    init(
        id: Int = 0,
        catId: Int = 0,
        brandId: Int = 0,
        typeId: Int = 0,
        name: String = "",
        detail: String = "",
        unitName: String = "",
        unitValue: String = "",
        nutritionWeight: String = "",
        offerPrice: Double? = nil,
        startDate: Date? = nil,
        endDate: Date? = nil,
        price: Double = 0,
        image: String = "",
        catName: String = "",
        typeName: String = "",
        isFav: Bool = false,
        avgRating: Double = 0
    ) {
        self.id = id
        self.catId = catId
        self.brandId = brandId
        self.typeId = typeId
        self.name = name
        self.detail = detail
        self.unitName = unitName
        self.unitValue = unitValue
        self.nutritionWeight = nutritionWeight
        self.offerPrice = offerPrice
        self.startDate = startDate
        self.endDate = endDate
        self.price = price
        self.image = image
        self.catName = catName
        self.typeName = typeName
        self.isFav = isFav
        self.avgRating = avgRating
    }
    static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id
    }
}
