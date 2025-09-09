//
//  UserModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//

import Foundation

struct UserModel: Identifiable, Equatable, Codable {
    var id: Int
    var username: String
    var name: String
    var email: String
    var mobile: String
    var mobileCode: String
    var authToken: String
    var createdDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case id          = "user_id"
        case username    = "username"
        case name        = "name"
        case email       = "email"
        case mobile      = "mobile"
        case mobileCode  = "mobile_code"
        case authToken   = "auth_token"
        case createdDate = "created_date"
    }
    
    // MARK: - Custom Decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id          = try container.decode(Int.self, forKey: .id)
        username    = try container.decodeString(forKey: .username)
        name        = try container.decodeString(forKey: .name)
        email       = try container.decodeString(forKey: .email)
        mobile      = try container.decodeString(forKey: .mobile)
        mobileCode  = try container.decodeString(forKey: .mobileCode)
        authToken   = try container.decodeString(forKey: .authToken)
        createdDate = try? container.decodeDate(forKey: .createdDate)
    }
    
    // MARK: - Custom Init
    init(
        id: Int = 0,
        username: String = "",
        name: String = "",
        email: String = "",
        mobile: String = "",
        mobileCode: String = "",
        authToken: String = "",
        createdDate: Date? = nil
    ) {
        self.id = id
        self.username = username
        self.name = name
        self.email = email
        self.mobile = mobile
        self.mobileCode = mobileCode
        self.authToken = authToken
        self.createdDate = createdDate
    }
    
    // MARK: - Equatable (so sánh theo id)
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}


#if DEBUG
extension UserModel {
    static var mock: UserModel {
        UserModel(
            id: 999,
            username: "DebugUser",
            name: "Debug Name",
            email: "debug@test.com",
            mobile: "0123456789",
            mobileCode: "+84",
            authToken: "LhFRTu2Mr2oZ4NUs6IGy",
            createdDate: Date()
        )
    }
}
#endif
