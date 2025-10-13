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
    
    @Published var txtSearch: String = ""
    @Published var isLoading: Bool = false
    
    @Published var offerArr: [ProductModel] = []
    @Published var bestArr: [ProductModel] = []
    @Published var listArr: [ProductModel] = []
    @Published var typeArr: [TypeModel] = []
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    private(set) var didLoad: Bool = false
    
    init(homeService: HomeServiceProtocol = HomeService()) {
        self.homeService = homeService
        AppLogger.info("HomeViewModel initialized", category: .ui)
    }
    
    func loadIfNeeded() async {
        guard !didLoad else { return }
        await fetchData()
    }
    
    func fetchData() async {
        isLoading = true
        AppLogger.debug("Fetching home data...", category: .network)
        defer { isLoading = false }
        
        do {
            let data = try await homeService.fetchHomeData()
            if Task.isCancelled { return }
            offerArr = data.offers
            bestArr = data.bests
            listArr = data.list
            typeArr = data.types
            didLoad = true
            AppLogger.info("Fetched home data: \(offerArr.count) offers, \(bestArr.count) bests, \(listArr.count) products, \(typeArr.count) types", category: .network)
        } catch is CancellationError {
            AppLogger.debug("Home fetch cancelled", category: .network)
        } catch let error as NetworkErrorType {

            popupState.showErrorPopup(error.errorMessage)

        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Home data fetch failed (unexpected error): \(error.localizedDescription)", category: .network)
        }
    }
}

extension HomeViewModel: Resettable {
    func reset() {
        offerArr = []
        bestArr = []
        listArr = []
        typeArr = []
        didLoad = false
    }
}
