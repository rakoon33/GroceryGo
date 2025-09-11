//
//  AddUpdateDeliveryAddressView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI

struct AddUpdateDeliveryAddressView: View {
    
    @StateObject var addressVM = DeliveryAddressViewModel.shared
    var body: some View {
        ZStack {
            
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
    AddUpdateDeliveryAddressView()
}
