//
//  PaymentService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/9/25.
//

import Foundation

protocol PaymentServiceProtocol {
    func fetchPaymentMethodList() async throws -> [PaymentModel]
    func removePaymentMethod(payId: Int) async throws
    func addPaymentMethod(name: String, cardNumber: String, cardMonth: String, cardYear: String) async throws
}

final class PaymentService: PaymentServiceProtocol {
    
    func fetchPaymentMethodList() async throws -> [PaymentModel] {
        try await ServiceCall.post(
            path: Globs.SV_PAYMENT_METHOD_LIST,
            parameters: [:],
            isTokenRequired: true,
            responseType: [PaymentModel].self
        )
    }
    
    func removePaymentMethod(payId: Int) async throws {
        let params = ["pay_id": payId]
        
        // Vì API không trả payload cụ thể, chỉ cần gọi thành công là xong
        let _: EmptyPayload = try await ServiceCall.post(
            path: Globs.SV_REMOVE_PAYMENT_METHOD,
            parameters: params,
            isTokenRequired: true,
            responseType: EmptyPayload.self
        )
    }
    
    func addPaymentMethod(name: String, cardNumber: String, cardMonth: String, cardYear: String) async throws {
        let params = ["name": name, "card_number": cardNumber, "card_month": cardMonth, "card_year": cardYear]
        
        // Vì API không trả payload cụ thể, chỉ cần gọi thành công là xong
        let _: EmptyPayload = try await ServiceCall.post(
            path: Globs.SV_ADD_PAYMENT_METHOD,
            parameters: params,
            isTokenRequired: true,
            responseType: EmptyPayload.self
        )
    }
}
