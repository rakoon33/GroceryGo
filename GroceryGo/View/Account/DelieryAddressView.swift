//
//  DelieryAddressView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/9/25.
//

import SwiftUI

struct DelieryAddressView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    @StateObject var addressVM = DeliveryAddressViewModel.shared
    
    @State private var showSheet = false
    @State private var selectedAddress: AddressModel? = nil
    @State private var isEditing = false
    
    var body: some View {
        ZStack {
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(addressVM.listArr, id: \.id, content: {
                        aObj in
                        
                        DeliveryAddressRow(
                            aObj: aObj,
                            onRemove: { id in
                                Task {
                                    await addressVM.removeAddress(addressId: aObj.id)
                                }
                            },
                            onEdit: {
                                selectedAddress = aObj
                                addressVM.setAdd(aObj: aObj) 
                                isEditing = true
                                showSheet = true
                            }
                        )
                        
                    })
                }
                .padding(20)
                .padding(.top, .topInsets + 46)
                .padding(.bottom, .bottomInsets + 60)
            }
            
            VStack {
                HStack {
                    
                    Button {
                        navigationState.removeLast()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                    
                    Text("delivery_address".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                    
                    Button {
                        selectedAddress = nil
                        isEditing = false
                        showSheet = true
                        addressVM.clearAll()
                    } label: {
                        Image("add_white")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    .foregroundColor(.primaryText)
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2)
                
                Spacer()
                
            }
        }
        .task {
            await addressVM.fetchAddressList()
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showSheet) {
            AddUpdateDeliveryAddressView(
                editObj: selectedAddress ?? AddressModel(),
                isEdit: $isEditing
            )
        }
    }
}

#Preview {
    DelieryAddressView()
}
