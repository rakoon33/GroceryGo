//
//  ExploreViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//


import SwiftUI

@MainActor
final class ExploreViewModel: ObservableObject {
    
    static var shared: ExploreViewModel = ExploreViewModel()
    
    private let categoryService: CategoryServiceProtocol
    
    @Published var selectedTab: MainTab = .shop
    @Published var txtSearch: String = ""
    
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var listArr: [CategoryModel] = []
    
    init(categoryService: CategoryServiceProtocol = CategoryService()) {
        self.categoryService = categoryService
        AppLogger.info("ExploreViewModel initialized", category: .ui)
    }
    
    func fetchExploreData() async {
        
        isLoading = true
        AppLogger.debug("Fetching explore category list", category: .network)
        defer { isLoading = false }
        
        do {
            listArr = try await categoryService.fetchExploreList()
            AppLogger.info("Fetched \(listArr.count) categories", category: .network)
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
                AppLogger.error("Unauthorized in fetchExploreData: \(error.localizedDescription)", category: .network)
            } else {
                errorMessage = error.errorMessage
                showError = true
            }
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            AppLogger.error("Unexpected error while fetching categories: \(error.localizedDescription)", category: .network)
        }
        
    }
}

extension ExploreViewModel: Resettable {
    func reset() {
        listArr = []
        txtSearch = ""
        showError = false
        errorMessage = ""
    }
}
