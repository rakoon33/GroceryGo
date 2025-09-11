//
//  DelieryAddressView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/9/25.
//

import SwiftUI

struct DelieryAddressView: View {
    
    @Binding var path: NavigationPath
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
                        path.removeLast()
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
                        selectedAddress = nil // add mới
                        showSheet = true
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
        .sheet(isPresented: $showSheet) {
            AddUpdateDeliveryAddressView(
                editObj: selectedAddress ?? AddressModel(),
                isEdit: $isEditing
            )
            .presentationDetents([.large])          // full height
            .presentationDragIndicator(.hidden)     // ẩn cái thanh kéo
            .ignoresSafeArea()   
        }
        .overlay {
            if addressVM.showPopup {
                ZStack {
                    // nền đen fade chậm
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.6), value: addressVM.showPopup)
                    
                    // popup scale + fade rất chậm
                    StatusPopupView(
                        type: addressVM.popupType,
                        messageKey: LocalizedStringKey(addressVM.popupMessageKey),
                        buttonKey: "ok_button"
                    ) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            addressVM.showPopup = false
                        }
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.9, blendDuration: 0.3),
                        value: addressVM.showPopup
                    )
                }
                .zIndex(1)
            }
        }
    }
}

#Preview {
    DelieryAddressView(path: .constant(NavigationPath()))
}
