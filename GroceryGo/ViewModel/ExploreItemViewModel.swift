//
//  ExploreItemViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import SwiftUI

@MainActor
final class ExploreItemViewModel: ObservableObject {
    
    private let categoryService: CategoryServiceProtocol
    
    @Published var cObj: CategoryModel
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var listArr: [ProductModel] = []
    
    @Published var isFav: Bool = false
    @Published var isShowDetail: Bool = false
    @Published var isShowNutrition: Bool = false
    @Published var qty: Int = 1
    
    init(cObj: CategoryModel, categoryService: CategoryServiceProtocol = CategoryService()) {
        self.categoryService = categoryService
        self.cObj = cObj
        AppLogger.info("Init ExploreItemViewModel with category=\(cObj.name)", category: .ui)
        fetchExploreItem()
    }
    
    func fetchExploreItem() {
        Task {
            isLoading = true
            AppLogger.debug("Fetching explore items for catId=\(cObj.id)", category: .network)
            defer { isLoading = false }
            
            do {
                listArr = try await categoryService.fetchExploreCategoryItem(catId: cObj.id)
                AppLogger.info("Fetched \(listArr.count) items for category=\(cObj.name)", category: .network)
            } catch let error as NetworkErrorType {
                errorMessage = error.errorMessage
                showError = true
                AppLogger.error("NetworkErrorType while fetching items: \(error.errorMessage)", category: .network)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                AppLogger.error("Unexpected error while fetching items: \(error.localizedDescription)", category: .network)
            }
        }
    }
}
