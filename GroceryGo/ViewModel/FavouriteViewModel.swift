//
//  FavouriteModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 23/8/25.
//

import SwiftUI

final class FavouriteViewModel: ObservableObject {
  
    static var shared: FavouriteViewModel = FavouriteViewModel()
    
    private let favouriteService: FavouriteServiceProtocol
    
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var listArr: [FavouriteModel] = []
    
    init(favouriteService: FavouriteService = FavouriteService()) {
        
        self.favouriteService = favouriteService
        
    }
    
    func fetchFavouriteList() {
        isLoading = true
        favouriteService.fetchFavouriteList() { [weak self] result in
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
    
    func addOrRemoveFavourite(prodId: Int) {
            isLoading = true
            favouriteService.addOrRemoveFavourite(prodId: prodId) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        // Sau khi toggle thì reload lại danh sách
                        self.fetchFavouriteList()
                        HomeViewModel.shared.fetchData()
                    case .failure(let error):
                        self.errorMessage = error.errorMessage
                        self.showError = true
                    }
                    self.isLoading = false
                }
            }
        }
    
}

