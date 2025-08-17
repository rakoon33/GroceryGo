//
//  Globs.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 9/8/25.
//

import SwiftUI

struct Globs {
    static let AppName = "GroceryGo"
    
    static let userPayload = "user_payload"
    static let userLogin = "user_login"
    
    static let BASE_URL = "http://localhost:3001/api/app/"
    
    static let SV_LOGIN = BASE_URL + "login"
    static let SV_SIGN_UP = BASE_URL + "sign_up"
}

struct KKey {
    static let code = "status"
    static let message = "message"
    static let payload = "payload"
}

