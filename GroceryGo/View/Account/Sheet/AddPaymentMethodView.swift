//
//  AddPaymentMethodView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/9/25.
//


import SwiftUI

struct AddPaymentMethodView: View {
    
    @StateObject var payVM = PaymentViewModel.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(spacing: 15) {
                    VStack(alignment: .leading, spacing: 4) {
                        LineTextField(
                            title: "name_field".localized,
                            placeholder: "enter_name".localized,
                            txt: $payVM.txtName
                        )
                        if let error = payVM.fieldError["name"] {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        LineTextField(
                            title: "card_number_field".localized,
                            placeholder: "enter_card_number".localized,
                            txt: $payVM.txtCardNumber,
                            keyboardType: .numberPad
                        )
                        if let error = payVM.fieldError["number"] {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.red)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            LineTextField(
                                title: "card_month_field".localized,
                                placeholder: "mm_placeholder".localized,
                                txt: $payVM.txtCardMonth,
                                keyboardType: .numberPad
                            )
                            if let error = payVM.fieldError["month"] {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            LineTextField(
                                title: "card_year_field".localized,
                                placeholder: "yyyy_placeholder".localized,
                                txt: $payVM.txtCardYear,
                                keyboardType: .numberPad
                            )
                            if let error = payVM.fieldError["year"] {
                                Text(error)
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                        }
                    }
                    
                    RoundButton(title: "add_payment_button".localized) {
                        Task {
                            await payVM.addPaymentMethod()
                            if payVM.lastOperationSucceeded {
                                dismiss()
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    if !payVM.formErrorMessage.isEmpty {
                        Text(payVM.formErrorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.top, 4)
                    }
                }
                
                .padding(20)
                .padding(.top, .topInsets + 50)
                .padding(.bottom, .bottomInsets + 60)
            }
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                    
                    Text("add_payment_method".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2)
                
                Spacer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    AddPaymentMethodView()
}
