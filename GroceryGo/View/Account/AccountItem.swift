//
//  AccountItem.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/9/25.
//

import SwiftUI


enum AccountItem {
    case orders
    case myDetails
    case deliveryAddress
    case paymentMethods
    case promoCode
    case notifications
    case help
    case about

    var title: LocalizedStringKey {
        switch self {
        case .orders: return "orders"
        case .myDetails: return "my_details"
        case .deliveryAddress: return "delivery_address"
        case .paymentMethods: return "payment_methods"
        case .promoCode: return "promo_code"
        case .notifications: return "notifications"
        case .help: return "help"
        case .about: return "about"
        }
    }

    var icon: String {
        switch self {
        case .orders: return "a_order"
        case .myDetails: return "a_my_detail"
        case .deliveryAddress: return "a_delivery_address"
        case .paymentMethods: return "a_payment_methods"
        case .promoCode: return "a_promocode"
        case .notifications: return "a_notification"
        case .help: return "a_help"
        case .about: return "a_about"
        }
    }
}
