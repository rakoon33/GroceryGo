//
//  CartService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//

import Foundation

protocol CartServiceProtocol {
    func fetchCartList() async throws -> CartResponse
    func addToCart(prodId: Int, qty: Int) async throws 
    func updateCartQty(cartId: Int, prodId: Int, newQty: Int) async throws
    func removeFromCart(cartId: Int, prodId: Int) async throws
}

final class CartService: CartServiceProtocol {
    
    func fetchCartList() async throws -> CartResponse {
        try await ServiceCall.postRaw(
            path: Globs.SV_CART_LIST,
            parameters: [:],
            isTokenRequired: true,
            responseType: CartResponse.self
        )
    }
    
    func addToCart(prodId: Int, qty: Int) async throws {
        _ = try await ServiceCall.postRaw(
            path: Globs.SV_ADD_CART_LIST,
            parameters: ["prod_id": prodId, "qty": qty],
            isTokenRequired: true,
            responseType: APIResponse<EmptyPayload>.self
        )
        // Nếu không throw thì coi như success
    }
    
    func updateCartQty(cartId: Int, prodId: Int, newQty: Int) async throws {
        _ = try await ServiceCall.postRaw(
            path: Globs.SV_UPDATE_CART_LIST,
            parameters: ["cart_id": cartId, "prod_id": prodId, "new_qty": newQty],
            isTokenRequired: true,
            responseType: APIResponse<EmptyPayload>.self
        )
    }
    
    func removeFromCart(cartId: Int, prodId: Int) async throws {
        _ = try await ServiceCall.postRaw(
            path: Globs.SV_REMOVE_CART_LIST,
            parameters: ["cart_id": cartId, "prod_id": prodId],
            isTokenRequired: true,
            responseType: APIResponse<EmptyPayload>.self
        )
    }
}
