//
//  DelieryAddressViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI
import Foundation

@MainActor
final class DeliveryAddressViewModel: ObservableObject {
    
    static let shared = DeliveryAddressViewModel()
    
    private let addressService: AddressServiceProtocol
    
    @Published var txtName: String = ""
    @Published var txtMobile: String = ""
    @Published var txtAddress: String = ""
    @Published var txtCity: String = ""
    @Published var txtState: String = ""
    @Published var txtPostalCode: String = ""
    @Published var txtTypeName: String = ""
    
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    @Published var lastOperationSucceeded: Bool = false
    
    @Published var listArr: [AddressModel] = []
    
    init(addressService: AddressServiceProtocol = AddressService()) {
        self.addressService = addressService
        AppLogger.info("DeliveryAddressViewModel initialized", category: .ui)
    }
    
    
    func setAdd(aObj: AddressModel) {
        txtName = aObj.name
        txtMobile = aObj.phone
        txtAddress = aObj.address
        txtCity = aObj.city
        txtState = aObj.state
        txtPostalCode = aObj.postalCode
        txtTypeName = aObj.typeName
        
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
        
        guard validateInputs() else { return }
        
        loadingState.isLoading = true

        defer { loadingState.isLoading = false}
        do {
            try await addressService.addAddress(
                name: txtName,
                typeName: txtTypeName,
                phone: txtMobile,
                address: txtAddress,
                city: txtCity,
                state: txtState,
                postalCode: txtPostalCode
            )
            
            await fetchAddressList()
            popupState.showSuccessPopup("address_added")
            lastOperationSucceeded = true
            self.clearAll()
            AppLogger.info("addAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                lastOperationSucceeded = false
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            lastOperationSucceeded = false
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in addAddress: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Update
    func updateAddress(addressId: Int) async {
        guard validateInputs() else { return }
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            try await addressService.updateAddress(
                addressId: addressId,
                name: txtName,
                typeName: txtTypeName,
                phone: txtMobile,
                address: txtAddress,
                city: txtCity,
                state: txtState,
                postalCode: txtPostalCode
            )
            
            await fetchAddressList()
            
            popupState.showSuccessPopup("address_updated")
            lastOperationSucceeded = true
            self.clearAll()
            AppLogger.info("updateAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                lastOperationSucceeded = false
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            lastOperationSucceeded = false
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
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
    func clearAll() {
        txtName = ""
        txtMobile = ""
        txtAddress = ""
        txtCity = ""
        txtState = ""
        txtPostalCode = ""
        txtTypeName = "Home"
        
    }
    
    func validateInputs() -> Bool {
        if txtName.trimmingCharacters(in: .whitespaces).isEmpty {
            popupState.showErrorPopup("name_required")
            return false
        }
        if txtMobile.trimmingCharacters(in: .whitespaces).isEmpty {
            popupState.showErrorPopup("mobile_required")
            return false
        }
        if txtAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            popupState.showErrorPopup("address_required")
            return false
        }
        if txtCity.trimmingCharacters(in: .whitespaces).isEmpty {
            popupState.showErrorPopup("city_required")
            return false
        }
        if txtState.trimmingCharacters(in: .whitespaces).isEmpty {
            popupState.showErrorPopup("state_required")
            return false
        }
        if txtPostalCode.trimmingCharacters(in: .whitespaces).isEmpty {
            popupState.showErrorPopup("postal_code_required")
            return false
        }
        return true
    }
    
}

// MARK: - Reset
extension DeliveryAddressViewModel: Resettable {
    func reset() {
        listArr = []
    }
}
