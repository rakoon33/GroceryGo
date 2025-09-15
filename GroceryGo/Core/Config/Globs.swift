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
    
    static let SV_UPDATE_CART_LIST = BASE_URL + "update_cart"
    static let SV_REMOVE_CART_LIST = BASE_URL + "remove_cart"
    static let SV_ADD_CART_LIST = BASE_URL + "add_to_cart"
    static let SV_CART_LIST = BASE_URL + "cart_list"
    
    static let SV_ADD_ADDRESS    = BASE_URL + "add_delivery_address"
    static let SV_UPDATE_ADDRESS = BASE_URL + "update_delivery_address"
    static let SV_REMOVE_ADDRESS = BASE_URL + "delete_delivery_address"
    static let SV_ADDRESS_LIST   = BASE_URL + "delivery_address"
    
    static let SV_PROMO_CODE_LIST = BASE_URL + "promo_code_list"
    
    static let SV_EXPLORE_LIST = BASE_URL + "explore_category_list"
    static let SV_EXPLORE_ITEM_LIST = BASE_URL + "explore_category_items_list"
}

struct APIHeader {
    static let tokenHeader = "access_token"
}

struct AuthToken: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}

