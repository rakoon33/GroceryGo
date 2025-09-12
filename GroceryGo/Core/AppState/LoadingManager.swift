//
//  LoadingManager.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 12/9/25.
//


import SwiftUI

@MainActor
final class LoadingManager: ObservableObject {
    static let shared = LoadingManager()
    
    @Published var isLoading: Bool = false
    
    private init() {}
    
    func show() {
        isLoading = true
    }
    
    func hide() {
        isLoading = false
    }
}
