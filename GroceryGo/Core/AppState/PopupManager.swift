//
//  PopupManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 12/9/25.
//


import SwiftUI

@MainActor
final class PopupManager: ObservableObject {
    static let shared = PopupManager()
    
    @Published var showPopup: Bool = false
    @Published var popupMessageKey: String = ""
    @Published var popupType: PopupType = .success
    
    private init() {}
    
    func showPopup(_ messageKey: String, type: PopupType) {
        popupType = type
        popupMessageKey = messageKey
        showPopup = true
    }
    
    func showErrorPopup(_ messageKey: String) {
        showPopup(messageKey, type: .error)
    }
    
    func showSuccessPopup(_ messageKey: String) {
        showPopup(messageKey, type: .success)
    }
    
    func dismissPopup() {
        showPopup = false
        popupMessageKey = ""
    }
}
