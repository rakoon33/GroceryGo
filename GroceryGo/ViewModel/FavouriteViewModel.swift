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
    
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var listArr: [FavouriteModel] = []
    
    init(favouriteService: FavouriteServiceProtocol = FavouriteService()) {
        self.favouriteService = favouriteService
        AppLogger.info("FavouriteViewModel initialized", category: .ui)
    }
    
    func fetchFavouriteList() async {
        isLoading = true
        AppLogger.debug("Fetching favourite list...", category: .network)
        defer { isLoading = false }
        
        do {
            listArr = try await favouriteService.fetchFavouriteList()
            AppLogger.info("Fetched \(listArr.count) favourite items", category: .network)
        } catch let error as NetworkErrorType {
            errorMessage = error.errorMessage
            showError = true
            AppLogger.error("Network error in fetchFavouriteList: \(error.errorMessage)", category: .network)
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            AppLogger.error("Unexpected error in fetchFavouriteList: \(error.localizedDescription)", category: .network)
        }
    }

    func addOrRemoveFavourite(prodId: Int) {
        Task { [weak self] in
            guard let self else { return }
            isLoading = true
            AppLogger.debug("Toggling favourite for prodId=\(prodId)", category: .network)
            defer { isLoading = false }
            
            do {
                try await favouriteService.addOrRemoveFavourite(prodId: prodId)
                AppLogger.info("Toggled favourite success for prodId=\(prodId)", category: .network)
                
                await fetchFavouriteList()
                HomeViewModel.shared.fetchData()
            } catch let error as NetworkErrorType {
                errorMessage = error.errorMessage
                showError = true
                AppLogger.error("Network error in addOrRemoveFavourite: \(error.errorMessage)", category: .network)
            } catch {
                errorMessage = error.localizedDescription
                showError = true
                AppLogger.error("Unexpected error in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
            }
        }
    }
}
