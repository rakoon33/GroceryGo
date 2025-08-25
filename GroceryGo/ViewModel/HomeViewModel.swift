//
//  HomeViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

final class HomeViewModel: ObservableObject {
  
    static var shared: HomeViewModel = HomeViewModel()
    
    private let homeService: HomeServiceProtocol
    
    @Published var selectedTab: MainTab = .shop
    @Published var txtSearch: String = ""
    
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var offerArr: [ProductModel] = []
    @Published var bestArr: [ProductModel] = []
    @Published var listArr: [ProductModel] = []
    @Published var typeArr: [TypeModel] = []
    
    init(homeService: HomeServiceProtocol = HomeService()) {
        
        self.homeService = homeService

    }
    
    func fetchData() {
        isLoading = true
        homeService.fetchHomeData() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.offerArr = data.offers
                    self.bestArr = data.bests
                    self.listArr = data.list
                    self.typeArr = data.types
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

