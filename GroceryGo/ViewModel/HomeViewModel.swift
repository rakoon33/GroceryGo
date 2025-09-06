//
//  HomeViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

@MainActor
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
        AppLogger.info("HomeViewModel initialized", category: .ui)
    }
    
    func fetchData() {
        Task { [weak self] in
            guard let self else { return }
            isLoading = true
            AppLogger.debug("Fetching home data...", category: .network)
            defer { isLoading = false }
            
            do {
                let data = try await homeService.fetchHomeData()
                offerArr = data.offers
                bestArr = data.bests
                listArr = data.list
                typeArr = data.types
                AppLogger.info("Fetched home data: \(offerArr.count) offers, \(bestArr.count) bests, \(listArr.count) products, \(typeArr.count) types", category: .network)
            } catch let error as NetworkErrorType {
                errorMessage = error.errorMessage
                showError = true
                AppLogger.error("Home data fetch failed (network error): \(error.errorMessage)", category: .network)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                AppLogger.error("Home data fetch failed (unexpected error): \(error.localizedDescription)", category: .network)
            }
        }
    }

}
