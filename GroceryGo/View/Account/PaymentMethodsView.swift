//
//  PaymentMethodsView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI

struct PaymentMethodsView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    @StateObject var payVM = PaymentViewModel.shared
    
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(payVM.listArr, id: \.id) { pObj in
                        PaymentMethodCell(pObj: pObj) {
                            Task { await payVM.removePaymentMethod(payId: pObj.id) }
                        }
                    }
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
                    
                    Text("payment_methods".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                    
                    Button {
                        showSheet = true
                        payVM.clearAll()
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
            await payVM.fetchPaymentMethodList()
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showSheet) {
            AddPaymentMethodView()
        }
    }
}


#Preview {
    PaymentMethodsView()
}
