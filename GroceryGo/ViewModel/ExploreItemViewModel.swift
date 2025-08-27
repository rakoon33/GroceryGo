//
//  ExploreItemViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import SwiftUI

final class ExploreItemViewModel: ObservableObject {

    private let categoryService: CategoryServiceProtocol
    
    @Published var cObj: CategoryModel = CategoryModel()
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
        isLoading = true

        categoryService.fetchExploreCategoryItem(catId: self.cObj.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.listArr = data
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.showError = true
                    self.isLoading = false
                }
            }
        }
    }
}

