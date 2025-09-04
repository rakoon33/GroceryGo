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
        fetchExploreItem()
    }
    
    func fetchExploreItem() {
        Task {
            isLoading = true
            do {
                listArr = try await categoryService.fetchExploreCategoryItem(catId: cObj.id)
                isLoading = false
            } catch let error as NetworkErrorType {
                errorMessage = error.errorMessage
                showError = true
                isLoading = false
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                isLoading = false
            }
        }
    }
}
