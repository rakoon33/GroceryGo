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
    
    @Published var listArr: [CategoryModel] = []
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    private(set) var didLoad: Bool = false
    
    init(categoryService: CategoryServiceProtocol = CategoryService()) {
        self.categoryService = categoryService
        AppLogger.info("ExploreViewModel initialized", category: .ui)
    }
    
    func loadIfNeeded() async {
        guard !didLoad else { return }
        await fetchExploreData()
    }
    
    func fetchExploreData() async {
        loadingState.isLoading = true
        AppLogger.debug("Fetching explore category list", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            let list = try await categoryService.fetchExploreList()
            if Task.isCancelled { return }
            listArr = list
            didLoad = true
            AppLogger.info("Fetched \(listArr.count) categories", category: .network)
        } catch is CancellationError {
            AppLogger.debug("Explore fetch cancelled", category: .network)
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error while fetching categories: \(error.localizedDescription)", category: .network)
        }
    }
}

extension ExploreViewModel: Resettable {
    func reset() {
        listArr = []
        txtSearch = ""
        didLoad = false
    }
}
