//
//  CartViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 4/9/25.
//

import SwiftUI

@MainActor
final class CartViewModel: ObservableObject {
    
    static var shared: CartViewModel = CartViewModel()
    
    private let cartService: CartServiceProtocol
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    @Published var listArr: [CartItemModel] = []
    @Published var total: Double = 0.0
    @Published var discount: Double = 0.0
    @Published var shippingFee: Double = 0.0
    @Published var finalPrice: Double = 0.0
    
    init(cartService: CartServiceProtocol = CartService()) {
        self.cartService = cartService
        AppLogger.info("CartViewModel initialized", category: .ui)
    }
    
    func fetchCartList() async {
        loadingState.isLoading = true
        AppLogger.debug("Fetching cart list...", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            let response = try await cartService.fetchCartList()
            
            // update state
            listArr = response.payload
            total = response.total
            discount = response.discountAmount
            shippingFee = response.deliverPriceAmount
            finalPrice = response.userPayPrice
            
            AppLogger.info("Fetched \(listArr.count) cart items", category: .ui)
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in fetchCartList: \(error.localizedDescription)", category: .network)
        }
    }
    
    func addProductToCart(prodId: Int, qty: Int) async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            try await cartService.addToCart(prodId: prodId, qty: qty)
            await fetchCartList()
            
            popupState.showSuccessPopup("added_to_cart")
            AppLogger.info("addProductToCart successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in addProductToCart: \(error.localizedDescription)", category: .network)
        }
    }
    
    func updateCartQty(cartId: Int, prodId: Int, newQty: Int) async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            try await cartService.updateCartQty(cartId: cartId, prodId: prodId, newQty: newQty)
            await fetchCartList()

            popupState.showSuccessPopup("cart_updated")
            AppLogger.info("updateCartQty successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in updateCartQty: \(error.localizedDescription)", category: .network)
        }
    }
    
    func removeFromCart(cartId: Int, prodId: Int) async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            try await cartService.removeFromCart(cartId: cartId, prodId: prodId)
            await fetchCartList()
            
            popupState.showSuccessPopup("removed_from_cart")
            AppLogger.info("removeFromCart successful", category: .ui)
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in removeFromCart: \(error.localizedDescription)", category: .network)
        }
    }
}

extension CartViewModel: Resettable {
    func reset() {
        listArr = []
        total = 0
        discount = 0
        shippingFee = 0
        finalPrice = 0
    }
}
