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
    
    @Published var listArr: [ProductModel] = []
    
    @Published var isFav: Bool = false
    @Published var isShowDetail: Bool = false
    @Published var isShowNutrition: Bool = false
    @Published var qty: Int = 1
    
    @Published var showPopup = false
    @Published var popupType: PopupType = .success
    @Published var popupMessageKey: String = ""
    
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
                if case .unauthorized = error {
                    // Đẩy sang SessionManager để logout, không show alert
                    SessionManager.shared.logout()
                    AppLogger.error("Unauthorized in fetchExploreItem: \(error.localizedDescription)", category: .network)
                } else {
                    popupType = .error
                    popupMessageKey = error.errorMessage
                    showPopup = true
                    AppLogger.error("Unexpected error in fetchExploreItem: \(error.localizedDescription)", category: .network)
                }
            } catch {
                popupType = .error
                popupMessageKey = error.localizedDescription
                showPopup = true
                AppLogger.error("Unexpected error while fetching items: \(error.localizedDescription)", category: .network)
            }
        }
    }
}
