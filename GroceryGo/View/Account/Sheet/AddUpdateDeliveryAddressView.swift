//
//  AddUpdateDeliveryAddressView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI


struct AddUpdateDeliveryAddressView: View {
    
    @StateObject var addressVM = DeliveryAddressViewModel.shared
    @Environment(\.dismiss) var dismiss
    @State var editObj: AddressModel = AddressModel()
    @Binding var isEdit: Bool
    var body: some View {
        ZStack {
            
            ScrollView {
                VStack(spacing: 15) {
                    HStack {
                        ForEach(AddressType.allCases, id: \.self) { type in
                            Button {
                                addressVM.txtTypeName = type.rawValue
                            } label: {
                                Image(systemName: addressVM.txtTypeName == type.rawValue ? "record.circle" : "circle")
                                    .renderingMode(.template)
                                    .foregroundColor(addressVM.txtTypeName == type.rawValue ? .primaryApp : .primaryText)
                                Text(type.localized)
                                    .font(.customfont(.medium, fontSize: 16))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            }
                            .foregroundColor(.primaryText)
                        }
                    }
                    
                    // Name
                    LineTextField(
                        title: "name_field".localized,
                        placeholder: "enter_name".localized,
                        txt: $addressVM.txtName
                    )
                    if let error = addressVM.fieldError["name"] {
                        Text(error)
                            .font(.customfont(.medium, fontSize: 16))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.red)
                    }
                    
                    // Mobile
                    LineTextField(
                        title: "mobile_field".localized,
                        placeholder: "enter_mobile".localized,
                        txt: $addressVM.txtMobile,
                        keyboardType: .numberPad
                    )
                    if let error = addressVM.fieldError["mobile"] {
                        Text(error)
                            .font(.customfont(.medium, fontSize: 16))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.red)
                    }
                    
                    // Address
                    LineTextField(
                        title: "address_line_field".localized,
                        placeholder: "enter_address".localized,
                        txt: $addressVM.txtAddress
                    )
                    if let error = addressVM.fieldError["address"] {
                        Text(error)
                            .font(.customfont(.medium, fontSize: 16))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.red)
                    }
                    
                    HStack{
                        VStack {
                            LineTextField(
                                title: "city_field".localized,
                                placeholder: "enter_city".localized,
                                txt: $addressVM.txtCity
                            )
                            if let error = addressVM.fieldError["city"] {
                                Text(error)
                                    .font(.customfont(.medium, fontSize: 16))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.red)
                            }
                        }
                        VStack {
                            LineTextField(
                                title: "state_field".localized,
                                placeholder: "enter_state".localized,
                                txt: $addressVM.txtState
                            )
                            if let error = addressVM.fieldError["state"] {
                                Text(error)
                                    .font(.customfont(.medium, fontSize: 16))
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.red)
                            }
                        }
                    }
                    
                    LineTextField(
                        title: "postal_code_field".localized,
                        placeholder: "enter_postal_code".localized,
                        txt: $addressVM.txtPostalCode
                    )
                    if let error = addressVM.fieldError["postal"] {
                        Text(error)
                            .font(.customfont(.medium, fontSize: 16))
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(Color.red)
                    }
                    
                    // Submit
                    RoundButton(
                        title: isEdit ? "update_address_button".localized : "add_address_button".localized
                    ) {
                        if isEdit {
                            Task {
                                await addressVM.updateAddress(addressId: editObj.id)
                                if addressVM.lastOperationSucceeded {
                                    dismiss()
                                }
                            }
                        } else {
                            Task {
                                await addressVM.addAddress()
                                if addressVM.lastOperationSucceeded {
                                    dismiss()
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                    
                    // API error dưới nút
                    if !addressVM.formErrorMessage.isEmpty {
                        Text(addressVM.formErrorMessage)
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
                    
                    Text(isEdit ? "edit_delivery_address".localized : "add_delivery_address".localized)
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
    AddUpdateDeliveryAddressView(isEdit: .constant(true))
}
