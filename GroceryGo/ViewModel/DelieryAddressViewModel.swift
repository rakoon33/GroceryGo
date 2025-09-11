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
    
    @Published var isLoading: Bool = false
    
    @Published var showPopup = false
    @Published var popupType: PopupType = .success
    @Published var popupMessageKey: String = ""
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
        isLoading = true
        defer { isLoading = false }
        
        do {
            listArr = try await addressService.fetchAddressList()
            AppLogger.info("Fetched \(listArr.count) addresses", category: .ui)
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
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
            AppLogger.error("Unexpected error in fetchAddressList: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Add
    func addAddress() async {
        
        guard validateInputs() else { return }
        
        isLoading = true
        
        defer {
            isLoading = false
        }
        
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
            popupType = .success
            popupMessageKey = "address_added"
            showPopup = true
            lastOperationSucceeded = true
            self.clearAll()
            AppLogger.info("addAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                lastOperationSucceeded = false
                popupType = .error
                popupMessageKey = error.errorMessage
                showPopup = true
            }
        } catch {
            lastOperationSucceeded = false
            popupType = .error
            popupMessageKey = "address_add_failed"
            showPopup = true
            AppLogger.error("Unexpected error in addAddress: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Update
    func updateAddress(addressId: Int) async {
        
        guard validateInputs() else { return }
        
        isLoading = true
        defer {
            isLoading = false
        }
        
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
            
            popupType = .success
            popupMessageKey = "address_updated"
            showPopup = true
            lastOperationSucceeded = true
            self.clearAll()
            AppLogger.info("updateAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                lastOperationSucceeded = false
                popupType = .error
                popupMessageKey = error.errorMessage
                showPopup = true
            }
        } catch {
            lastOperationSucceeded = false
            popupType = .error
            popupMessageKey = "address_update_failed"
            showPopup = true
            AppLogger.error("Unexpected error in updateAddress: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Remove
    func removeAddress(addressId: Int) async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            _ = try await addressService.removeAddress(addressId: addressId)
            
            await fetchAddressList()
            
            popupType = .success
            popupMessageKey = "address_removed"
            showPopup = true
            AppLogger.info("removeAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                popupType = .error
                popupMessageKey = error.errorMessage
                showPopup = true
            }
        } catch {
            popupType = .error
            popupMessageKey = "address_remove_failed"
            showPopup = true
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
            showError(messageKey: "name_required")
            return false
        }
        if txtMobile.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(messageKey: "mobile_required")
            return false
        }
        if txtAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(messageKey: "address_required")
            return false
        }
        if txtCity.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(messageKey: "city_required")
            return false
        }
        if txtState.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(messageKey: "state_required")
            return false
        }
        if txtPostalCode.trimmingCharacters(in: .whitespaces).isEmpty {
            showError(messageKey: "postal_code_required")
            return false
        }
        return true
    }
    
    private func showError(messageKey: String) {
        popupType = .error
        popupMessageKey = messageKey
        showPopup = true
    }
}

// MARK: - Reset
extension DeliveryAddressViewModel: Resettable {
    func reset() {
        listArr = []
        showPopup = false
        popupType = .success
        popupMessageKey = ""
    }
}
