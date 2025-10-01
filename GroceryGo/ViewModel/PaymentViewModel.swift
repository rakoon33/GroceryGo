//
//  PaymentViewModel.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/9/25.
//

import SwiftUI

@MainActor
final class PaymentViewModel: ObservableObject {
    
    static var shared: PaymentViewModel = PaymentViewModel()
    
    private let paymentSerice: PaymentServiceProtocol
    
    @Published var txtName: String = ""
    @Published var txtCardNumber: String = ""
    @Published var txtCardMonth: String = ""
    @Published var txtCardYear: String = ""
    
    @Published var listArr: [PaymentModel] = []
    
    @Published var fieldError: [String: String] = [:]
    @Published var formErrorMessage: String = ""
    
    @Published var lastOperationSucceeded: Bool = false
    private let loadingState = LoadingManager.shared
    private let popupState = PopupManager.shared
    
    init(paymentSerice: PaymentServiceProtocol = PaymentService()) {
        self.paymentSerice = paymentSerice
        AppLogger.info("PaymentViewModel initialized", category: .ui)
    }
    
    func clearAll() {
        txtName = ""
        txtCardNumber = ""
        txtCardMonth = ""
        txtCardYear = ""
    }
    
    func setData(pObj: PaymentModel) {
        txtName = pObj.name
        txtCardNumber = pObj.cardNumber
        txtCardYear = pObj.cardYear
        txtCardMonth = pObj.cardMonth
    }
    
    func fetchPaymentMethodList() async {
        loadingState.isLoading = true
        AppLogger.debug("Fetching favourite list...", category: .network)
        defer { loadingState.isLoading = false }
        
        do {
            listArr = try await paymentSerice.fetchPaymentMethodList()
            AppLogger.info("Fetched \(listArr.count) favourite items", category: .network)
        } catch let error as NetworkErrorType {
            popupState.showErrorPopup(error.errorMessage)
            AppLogger.error("Network error in fetchFavouriteList: \(error.errorMessage)", category: .network)
        } catch {
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in fetchFavouriteList: \(error.localizedDescription)", category: .network)
        }
    }
    
    func addPaymentMethod() async {
        guard validateInputs() else { return }
        loadingState.isLoading = true
        formErrorMessage = ""
        defer { loadingState.isLoading = false }
        
        do {
            try await paymentSerice.addPaymentMethod(name: txtName, cardNumber: txtCardNumber, cardMonth: txtCardMonth, cardYear: txtCardYear)
            AppLogger.info("addPaymentMethod for \(txtName), \(txtCardNumber)", category: .network)
            
            await fetchPaymentMethodList()
            lastOperationSucceeded = true
            clearAll()
            popupState.showSuccessPopup("add_payment_success")
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
                AppLogger.error("Unauthorized in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
            } else {
                lastOperationSucceeded = false
                formErrorMessage = error.errorMessage
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            lastOperationSucceeded = false
            formErrorMessage = error.localizedDescription
            popupState.showErrorPopup(error.localizedDescription)
            AppLogger.error("Unexpected error in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
        }
    }
    
    func removePaymentMethod(payId: Int) async {
        loadingState.isLoading = true
        defer { loadingState.isLoading = false }
        
        do {
            try await paymentSerice.removePaymentMethod(payId: payId)
            AppLogger.info("Delete payment method for payId=\(payId)", category: .network)
            
            await fetchPaymentMethodList()
            
            lastOperationSucceeded = true
            popupState.showSuccessPopup("favourite_updated")
            
            
        } catch let error as NetworkErrorType {
            if case .unauthorized = error {
                // Đẩy sang SessionManager để logout, không show alert
                SessionManager.shared.logout()
                AppLogger.error("Unauthorized in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
            } else {
                lastOperationSucceeded = false
                popupState.showErrorPopup(error.errorMessage)
            }
        } catch {
            lastOperationSucceeded = false
            popupState.showErrorPopup((error as? NetworkErrorType)?.errorMessage ?? error.localizedDescription)
            AppLogger.error("Unexpected error in addOrRemoveFavourite: \(error.localizedDescription)", category: .network)
        }
    }
    
    //MARK: helpers
    
    func validateInputs() -> Bool {
        fieldError = [:]
        
        if txtName.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["name"] = "card_name_required".localized
        }
        if txtCardNumber.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["number"] = "card_number_required".localized
        }
        if txtCardMonth.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["month"] = "card_month_required".localized
        }
        if txtCardYear.trimmingCharacters(in: .whitespaces).isEmpty {
            fieldError["year"] = "card_year_required".localized
        }
        
        return fieldError.isEmpty
    }
    
}

extension PaymentViewModel: Resettable {
    func reset() {
        
        txtName = ""
        txtCardNumber = ""
        txtCardMonth = ""
        txtCardYear = ""
        
        listArr = []
    }
}
