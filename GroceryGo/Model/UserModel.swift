//
//  UserModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/8/25.
//

import SwiftUI

struct UserModel: Identifiable, Equatable, Codable {
    var id: Int
    var username: String
    var name: String
    var email: String
    var mobile: String
    var mobileCode: String
    var authToken: String
    var createdDate: Date
    
    enum CodingKeys: String, CodingKey {
        // MAP với bên BE
        case id = "user_id"
        case username = "username"
        case name = "name"
        case email = "email"
        case mobile = "mobile"
        case mobileCode = "mobile_code"
        case authToken = "auth_token"
        case createdDate = "created_date"
    }
    
    // So sánh dựa trên id (Dùng Equatable là ok r nhưng muốn tự định nghĩa thì viết hàm này)
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        return lhs.id == rhs.id
    }
}
