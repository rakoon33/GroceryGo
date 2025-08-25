//
//  ExploreViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//


import SwiftUI

final class ExploreViewModel: ObservableObject {
  
    static var shared: ExploreViewModel = ExploreViewModel()
    
    private let exploreService: ExploreServiceProtocol
    
    @Published var selectedTab: MainTab = .shop
    @Published var txtSearch: String = ""
    
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var listArr: [ExploreCategoryModel] = []

    init(exploreService: ExploreServiceProtocol = ExploreService()) {
        
        self.exploreService = exploreService

    }
    
    func fetchExploreData() {
        isLoading = true
        exploreService.fetchExploreList() { [weak self] result in
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

