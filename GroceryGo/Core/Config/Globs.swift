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
    static let SV_HOME = BASE_URL + "home"
    static let SV_PRODUCT_DETAIL = BASE_URL + "product_detail"
    static let SV_ADD_REMOVE_FAVOURITE = BASE_URL + "add_remove_favorite"
    static let SV_FAVOURITE_LIST = BASE_URL + "favorite_list"
    
    static let SV_EXPLORE_LIST = BASE_URL + "explore_category_list"
    static let SV_EXPLORE_ITEM_LIST = BASE_URL + "explore_category_items_list"
}

struct KKey {
    static let code = "status"
    static let message = "message"
    static let payload = "payload"
}

struct APIHeader {
    static let tokenHeader = "access_token"
}
