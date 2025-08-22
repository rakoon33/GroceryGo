//
//  ProductDetailViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//


import SwiftUI

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
    
    func showDetail() {
        isShowDetail.toggle()
    }
    
    func showNutritions() {
        isShowNutrition.toggle()
    }
    
    func addSubQTY(isAdd: Bool = true) {
        if(isAdd) {
            qty += 1
            if(qty > 99) {
                qty = 99
            }
        } else {
            qty -= 1
            if(qty < 1) {
                qty = 1
            }
        }
    }
    
    init(prodObj: ProductModel, productService: ProductService = ProductService()) {
        
        self.productService = productService
        self.pObj = prodObj
        self.isFav = pObj.isFav
        
        
        fetchProductDetail()
    }
    
    
    func fetchProductDetail() {
        isLoading = true

        productService.fetchProductDetail(prod_id: self.pObj.id) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let data):
                    self.pObj = data.product
                    self.nutritionArr = data.nutritions
                    self.imageArr = data.images
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

