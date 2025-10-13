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
    
    private(set) var didLoad: Bool = false
    
    init(favouriteService: FavouriteServiceProtocol = FavouriteService()) {
        self.favouriteService = favouriteService
        AppLogger.info("FavouriteViewModel initialized", category: .ui)
    }
    
    func loadIfNeeded() async {
        guard !didLoad else { return }
        await fetchFavouriteList()
    }
    
    func fetchFavouriteList() async {
        loadingState.isLoading = true
        AppLogger.debug("Fetching favourite list...", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            listArr = try await favouriteService.fetchFavouriteList()
            if Task.isCancelled { return }
            didLoad = true
            AppLogger.info("Fetched \(listArr.count) favourite items", category: .network)
        } catch is CancellationError {
            AppLogger.debug("Favourite fetch cancelled", category: .network)
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
            await fetchFavouriteList()
            
            popupState.showSuccessPopup("favourite_updated")

        } catch is CancellationError {
            AppLogger.debug("Toggle favourite cancelled", category: .network)
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
        }
    }
}

extension FavouriteViewModel: Resettable {
    func reset() {
        listArr = []
        didLoad = false
    }
}
