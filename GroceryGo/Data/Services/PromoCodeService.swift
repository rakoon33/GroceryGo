//
//  PromoCodeService.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/9/25.
//

import Foundation

protocol PromoCodeServiceProtocol {
    func fetchPromoCodeList() async throws -> [PromoCodeModel]
}

final class PromoCodeService: PromoCodeServiceProtocol {
    
    func fetchPromoCodeList() async throws -> [PromoCodeModel] {
        try await ServiceCall.post(
            path: Globs.SV_PROMO_CODE_LIST,
            parameters: [:],
            isTokenRequired: true,
            responseType: [PromoCodeModel].self
        )
    }
}
