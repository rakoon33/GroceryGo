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
    
    @Published var suppressPopup = false
    
    private init() {}
    
    func showPopup(_ messageKey: String, type: PopupType) {
        guard !suppressPopup else { return }
        popupType = type
        popupMessageKey = messageKey
        showPopup = true
    }
    
    func showErrorPopup(_ messageKey: String) {
        guard !suppressPopup else { return }
        showPopup(messageKey, type: .error)
    }
    
    func showSuccessPopup(_ messageKey: String) {
        guard !suppressPopup else { return }
        showPopup(messageKey, type: .success)
    }
    
    func dismissPopup() {
        showPopup = false
        popupMessageKey = ""
    }
}
