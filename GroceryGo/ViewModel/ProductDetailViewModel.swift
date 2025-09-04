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
    @Published var isLoading: Bool = false
    @Published var showError = false
    @Published var errorMessage: String = ""
    
    @Published var nutritionArr: [NutritionModel] = []
    @Published var imageArr: [ImageModel] = []

    @Published var isFav: Bool = false
    @Published var isShowDetail: Bool = false
    @Published var isShowNutrition: Bool = false
    @Published var qty: Int = 1
    
    // MARK: - UI actions
    func showDetail() {
        isShowDetail.toggle()
    }
    
    func showNutritions() {
        isShowNutrition.toggle()
    }
    
    func toggleFavourite() {
        // update UI ngay
        isFav.toggle()
        FavouriteViewModel.shared.addOrRemoveFavourite(prodId: pObj.id)
    }
    
    func addSubQTY(isAdd: Bool = true) {
        if isAdd {
            qty = min(qty + 1, 99)
        } else {
            qty = max(qty - 1, 1)
        }
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
        isLoading = true
        defer { isLoading = false }
        do {
            let data = try await productService.fetchProductDetail(prodId: pObj.id)
            pObj = data.product
            nutritionArr = data.nutritions
            imageArr = data.images
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
    }
}
