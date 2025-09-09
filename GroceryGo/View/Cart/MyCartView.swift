//
//  MyCartView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//

import SwiftUI

struct MyCartView: View {
    
    @Binding var path: NavigationPath
    @StateObject var cartVM = CartViewModel.shared
    
    var body: some View {
        ZStack {
            
            if(cartVM.listArr.count == 0) {
                Text("cart_empty".localized)
                    .font(.customfont(.bold, fontSize: 20))
            }
            
            ScrollView {
                LazyVStack {
                    ForEach(cartVM.listArr, id: \.id, content: {
                        cObj in
                        
                        CartItemRow(cObj: cObj) {
//                            path.append(AppRoute.productDetail(cObj.product))
                        }
                    })
                    .padding(.vertical, 8)
                }
                .padding(20)
                .padding(.top, .topInsets + 46)
                .padding(.bottom, .bottomInsets + 60)
            }

            
            VStack {
                HStack {
                    Spacer()
                    
                    Text("my_cart_title".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                }
                .padding(.top, .topInsets)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2)
                
                Spacer()
                
                if(cartVM.listArr.count > 1) {
                    
                    
                    Button {

                    } label: {
                        ZStack {
                            Text("check_out".localized)
                                .font(.customfont(.semibold, fontSize: 18))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            
                            HStack {
                                
                                Spacer()
                                
                                Text("$\(cartVM.total, specifier: "%.2f")")
                                    .font(.customfont(.semibold, fontSize: 12))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.darkGray.opacity(0.2))
                                    .cornerRadius(5)
                            }
                            .padding(.trailing)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                    .background(Color.primaryApp)
                    .cornerRadius(20)
                    .padding(20)
                    .padding(.bottom, .bottomInsets + 80)
                
                }
            }
            
            SpinnerView(isLoading: $cartVM.isLoading)
        }
        .alert(isPresented: $cartVM.showError, content: {
            Alert(title: Text(Globs.AppName), message: Text(cartVM.errorMessage), dismissButton: .default(Text("ok_button".localized)))
        })
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        .task {
            await cartVM.fetchCartList()
        }
        .overlay {
            if cartVM.showPopup {
                ZStack {
                    // nền đen fade chậm
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.6), value: cartVM.showPopup)

                    // popup scale + fade rất chậm
                    StatusPopupView(
                        type: cartVM.popupType,
                        messageKey: LocalizedStringKey(cartVM.popupMessageKey),
                        buttonKey: "ok_button"
                    ) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            cartVM.showPopup = false
                        }
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.9, blendDuration: 0.3),
                        value: cartVM.showPopup
                    )
                }
                .zIndex(1)
            }
        }

    }
}

#Preview {
    MyCartView(path: .constant(NavigationPath()))
}
