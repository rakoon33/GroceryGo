//
//  AddressType.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 13/9/25.
//


enum AddressType: String, CaseIterable {
    case home
    case office
    
    var localized: String {
        switch self {
        case .home: return "home".localized
        case .office: return "office".localized
        }
    }
}
