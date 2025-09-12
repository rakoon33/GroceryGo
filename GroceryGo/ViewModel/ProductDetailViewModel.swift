//
//  ProductDetailViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import SwiftUI

@MainActor
final class ProductDetailViewModel: ObservableObject {
    
    private let productService: ProductServiceProtocol
    
    @Published var pObj: ProductModel = ProductModel()
    @Published var nutritionArr: [NutritionModel] = []
    @Published var imageArr: [ImageModel] = []
    
    @Published var isFav: Bool = false
    @Published var isShowDetail: Bool = false
    @Published var isShowNutrition: Bool = false
    @Published var qty: Int = 1
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    // MARK: - UI actions
    func showDetail() {
        isShowDetail.toggle()
    }
    
    func showNutritions() {
        isShowNutrition.toggle()
    }
    
    func toggleFavourite() async {
        isFav.toggle()
        AppLogger.debug("Toggle favourite for productId=\(pObj.id), now isFav=\(isFav)", category: .ui)
        await FavouriteViewModel.shared.addOrRemoveFavourite(prodId: pObj.id)
    }
    
    func addSubQTY(isAdd: Bool = true) {
        qty = isAdd ? min(qty + 1, 99) : max(qty - 1, 1)
    }
    
    // MARK: - Init
    init(prodObj: ProductModel, productService: ProductService = ProductService()) {
        self.productService = productService
        self.pObj = prodObj
        self.isFav = prodObj.isFav
        
        Task { [weak self] in
            await self?.fetchProductDetail()
        }
    }
    
    // MARK: - Fetch detail
    func fetchProductDetail() async {
        loadingState.isLoading = true
        AppLogger.debug("Fetching detail for productId=\(pObj.id)", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            let data = try await productService.fetchProductDetail(prodId: pObj.id)
            pObj = data.product
            nutritionArr = data.nutritions
            imageArr = data.images
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
                AppLogger.error("Unauthorized in fetchProductDetail: \(error.localizedDescription)", category: .network)
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error fetching product detail: \(error as? NetworkErrorType)?.errorMessage)", category: .network)
        }
    }
}

extension ProductDetailViewModel: Resettable {
    func reset() {
        pObj = ProductModel()
        nutritionArr = []
        imageArr = []
        isFav = false
        isShowDetail = false
        isShowNutrition = false
        qty = 1
    }
}
