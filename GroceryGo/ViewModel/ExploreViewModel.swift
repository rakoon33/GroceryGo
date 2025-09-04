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
    }
    
    func fetchExploreData() {
        Task { [weak self] in
            guard let self else { return }
            isLoading = true
            defer { isLoading = false }
            do {
                listArr = try await categoryService.fetchExploreList()
            } catch let error as NetworkErrorType {
                errorMessage = error.errorMessage
                showError = true
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }
}
