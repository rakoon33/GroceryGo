//
//  FavouriteModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 23/8/25.
//

import SwiftUI

@MainActor
final class FavouriteViewModel: ObservableObject {
    
    static var shared: FavouriteViewModel = FavouriteViewModel()
    
    private let favouriteService: FavouriteServiceProtocol
    
    @Published var listArr: [FavouriteModel] = []
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    init(favouriteService: FavouriteServiceProtocol = FavouriteService()) {
        self.favouriteService = favouriteService
        AppLogger.info("FavouriteViewModel initialized", category: .ui)
    }
    
    func fetchFavouriteList() async {
        loadingState.isLoading = true
        AppLogger.debug("Fetching favourite list...", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            listArr = try await favouriteService.fetchFavouriteList()
            AppLogger.info("Fetched \(listArr.count) favourite items", category: .network)
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
            AppLogger.error("Network error in fetchFavouriteList: \(error.errorMessage)", category: .network)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in fetchFavouriteList: \(error.localizedDescription)", category: .network)
        }
    }
    
    func addOrRemoveFavourite(prodId: Int) async {
        loadingState.isLoading = true
        AppLogger.debug("Toggling favourite for prodId=\(prodId)", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            try await favouriteService.addOrRemoveFavourite(prodId: prodId)
            AppLogger.info("Toggled favourite success for prodId=\(prodId)", category: .network)
            
            await fetchFavouriteList()
            await HomeViewModel.shared.fetchData()
            
            popupState.showSuccessPopup("favourite_updated")

        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
                AppLogger.error("Unauthorized in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
        }
    }
}

extension FavouriteViewModel: Resettable {
    func reset() {
        listArr = []
    }
}
