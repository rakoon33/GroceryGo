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
    
    private let addressService: AddressServiceProtocol
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    @Published var listArr: [AddressModel] = []
    
    init(addressService: AddressServiceProtocol = AddressService()) {
        self.addressService = addressService
        AppLogger.info("PromoCodeViewModel initialized", category: .ui)
    }
    
    
    // MARK: - Fetch
    func fetchAddressList() async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            listArr = try await addressService.fetchAddressList()
            AppLogger.info("Fetched \(listArr.count) addresses", category: .ui)
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in fetchAddressList: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Add
    func addAddress() async {
 
        loadingState.isLoading = true
        
        
        defer { loadingState.isLoading = false}
        do {
//            try await addressService.addAddress()
            
            await fetchAddressList()
            
            AppLogger.info("addAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup(error.localizedDescription)
            AppLogger.error("Unexpected error in addAddress: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Update
    func updateAddress(addressId: Int) async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
//            try await addressService.updateAddress()
            
            await fetchAddressList()
            AppLogger.info("updateAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup(error.localizedDescription)
            AppLogger.error("Unexpected error in updateAddress: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Remove
    func removeAddress(addressId: Int) async {
        
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            _ = try await addressService.removeAddress(addressId: addressId)
            
            await fetchAddressList()
            
            popupState.showSuccessPopup("address_removed")
            AppLogger.info("removeAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in removeAddress: \(error.localizedDescription)", category: .network)
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
