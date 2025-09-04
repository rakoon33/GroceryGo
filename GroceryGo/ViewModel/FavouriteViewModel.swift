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
    }
    
    func fetchFavouriteList() async {
        isLoading = true
        defer { isLoading = false }
        do {
            listArr = try await favouriteService.fetchFavouriteList()
        } catch let error as NetworkErrorType {
            errorMessage = error.errorMessage
            showError = true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }

    func addOrRemoveFavourite(prodId: Int) {
        Task { [weak self] in
            guard let self else { return }
            isLoading = true
            defer { isLoading = false }
            do {
                try await favouriteService.addOrRemoveFavourite(prodId: prodId)
                await fetchFavouriteList()
                HomeViewModel.shared.fetchData()
            } catch let error as NetworkErrorType {
                errorMessage = error.errorMessage
                showError = true
            } catch {
                errorMessage = error.localizedDescription
                showError = true
            }
        }
    }

}
