//
//  AddressModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import Foundation

struct AddressModel: Codable, Identifiable, Equatable {
    var id: Int
    var name: String
    var phone: String
    var address: String
    var city: String
    var state: String
    var typeName: String
    var postalCode: String
    var isDefault: Int
    
    enum CodingKeys: String, CodingKey {
        case id         = "address_id"
        case name       = "name"
        case phone      = "phone"
        case address    = "address"
        case city       = "city"
        case state      = "state"
        case typeName   = "type_name"
        case postalCode = "postal_code"
        case isDefault  = "is_default"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id         = try container.decode(Int.self, forKey: .id)
        name       = try container.decode(String.self, forKey: .name)
        phone      = try container.decode(String.self, forKey: .phone)
        address    = try container.decode(String.self, forKey: .address)
        city       = try container.decode(String.self, forKey: .city)
        state      = try container.decode(String.self, forKey: .state)
        typeName   = try container.decode(String.self, forKey: .typeName)
        postalCode = try container.decode(String.self, forKey: .postalCode)
        isDefault  = (try? container.decode(Int.self, forKey: .isDefault)) ?? 0
    }
    
    init(
        id: Int = 0,
        name: String = "",
        phone: String = "",
        address: String = "",
        city: String = "",
        state: String = "",
        typeName: String = "",
        postalCode: String = "",
        isDefault: Int = 0
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.address = address
        self.city = city
        self.state = state
        self.typeName = typeName
        self.postalCode = postalCode
        self.isDefault = isDefault
    }
    
    static func == (lhs: AddressModel, rhs: AddressModel) -> Bool {
        lhs.id == rhs.id
    }
}
