//
//  PromoCodeViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 15/9/25.
//

import SwiftUI

import SwiftUI
import Foundation

@MainActor
final class PromoCodeViewModel: ObservableObject {
    
    static let shared = PromoCodeViewModel()
    
    private let promoCodeService: PromoCodeServiceProtocol
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    @Published var listArr: [PromoCodeModel] = []
    
    init(promoCodeService: PromoCodeServiceProtocol = PromoCodeService()) {
        self.promoCodeService = promoCodeService
        AppLogger.info("PromoCodeViewModel initialized", category: .ui)
    }
    
    
    // MARK: - Fetch
    func fetchPromoCodeList() async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            listArr = try await promoCodeService.fetchPromoCodeList()
            AppLogger.info("Fetched \(listArr.count) addresses", category: .ui)
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in fetchAddressList: \(error.localizedDescription)", category: .network)
        }
    }
    

    // MARK: - helpers
    
}

// MARK: - Reset
extension PromoCodeViewModel: Resettable {
    func reset() {
        listArr = []
    }
}
