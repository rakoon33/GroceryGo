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
    
    @Published var fieldError: [String: String] = [:]
    @Published var formErrorMessage: String = ""

    @Published var listArr: [AddressModel] = []
    
    init(addressService: AddressServiceProtocol = AddressService()) {
        self.addressService = addressService
        self.txtTypeName = AddressType.home.rawValue
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
        
        formErrorMessage = ""
        
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
            lastOperationSucceeded = true
            clearAll()
            
            AppLogger.info("addAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                lastOperationSucceeded = false
                formErrorMessage = error.errorMessage
            }
        } catch {
            lastOperationSucceeded = false
            formErrorMessage = error.localizedDescription
            AppLogger.error("Unexpected error in addAddress: \(error.localizedDescription)", category: .network)
        }
    }
    
    // MARK: - Update
    func updateAddress(addressId: Int) async {
        guard validateInputs() else { return }
        loadingState.isLoading = true
        formErrorMessage = ""
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
            lastOperationSucceeded = true
            clearAll()
            AppLogger.info("updateAddress successful", category: .ui)
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                SessionManager.shared.logout()
            } else {
                lastOperationSucceeded = false
                formErrorMessage = error.errorMessage
            }
        } catch {
            lastOperationSucceeded = false
            formErrorMessage = error.localizedDescription
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
        fieldError = [:]
        
        if txtName.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["name"] = "name_required".localized
        }
        if txtMobile.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["mobile"] = "mobile_required".localized
        }
        if txtAddress.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["address"] = "address_required".localized
        }
        if txtCity.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["city"] = "city_required".localized
        }
        if txtState.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["state"] = "state_required".localized
        }
        if txtPostalCode.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["postal"] = "postal_code_required".localized
        }
        
        return fieldError.isEmpty
    }
    
}

// MARK: - Reset
extension DeliveryAddressViewModel: Resettable {
    func reset() {
        listArr = []
    }
}
