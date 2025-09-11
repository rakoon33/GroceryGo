//
//  DelieryAddressViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI

@MainActor
final class DelieryAddressViewModel: ObservableObject {
    
    static var shared: CartViewModel = CartViewModel()
    
    private let cartService: CartServiceProtocol
    
    @Published var isLoading: Bool = false
    
    @Published var showPopup = false
    @Published var popupType: PopupType = .success
    @Published var popupMessageKey: String = ""
    
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
        isLoading = true
        AppLogger.debug("Fetching cart list...", category: .network)
        defer { isLoading = false }
        
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
                popupType = .error
                popupMessageKey = error.errorMessage
                showPopup = true
            }
        } catch {
            popupType = .error
            popupMessageKey = error.localizedDescription
            showPopup = true
            AppLogger.error("Unexpected error in fetchCartList: \(error.localizedDescription)", category: .network)
        }
    }
    
    func addProductToCart(prodId: Int, qty: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await cartService.addToCart(prodId: prodId, qty: qty)
            await fetchCartList()
            
            popupType = .success
            popupMessageKey = "added_to_cart"
            showPopup = true
            AppLogger.info("addProductToCart successful", category: .ui)
            
        } catch {
            popupType = .error
            popupMessageKey = "add_to_cart_failed"
            showPopup = true
            AppLogger.error("Unexpected error in addProductToCart: \(error.localizedDescription)", category: .network)
        }
    }
    
    func updateCartQty(cartId: Int, prodId: Int, newQty: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await cartService.updateCartQty(cartId: cartId, prodId: prodId, newQty: newQty)
            await fetchCartList()
            
            popupType = .success
            popupMessageKey = "cart_updated"
            showPopup = true
            AppLogger.info("updateCartQty successful", category: .ui)
            
        } catch {
            popupType = .error
            popupMessageKey = "cart_update_failed"
            showPopup = true
            AppLogger.error("Unexpected error in updateCartQty: \(error.localizedDescription)", category: .network)
        }
    }
    
    func removeFromCart(cartId: Int, prodId: Int) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await cartService.removeFromCart(cartId: cartId, prodId: prodId)
            await fetchCartList()
            
            popupType = .success
            popupMessageKey = "removed_from_cart"
            showPopup = true
            AppLogger.info("removeFromCart successful", category: .ui)
        } catch {
            popupType = .error
            popupMessageKey = "remove_from_cart_failed"
            showPopup = true
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
        showPopup = false
        popupType = .success
        popupMessageKey = ""
    }
}
