//
//  ExploreItemView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import SwiftUI

struct ExploreItemView: View {

    @Binding var path: NavigationPath
    @StateObject var itemsVM = ExploreItemViewModel(cObj: CategoryModel())
    @StateObject var cartVM = CartViewModel.shared
    var column = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            
            VStack {
                HStack {
                    Button {
                        if !path.isEmpty {
                            path.removeLast()
                        }
                        
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Text(itemsVM.cObj.name)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    
                    
                    Button {
                    } label: {
                        Image("filter_ic")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                
                ScrollView {
                    LazyVGrid(columns: column, spacing: 15) {
                        ForEach(itemsVM.listArr, id: \.id) {
                            pObj in
                            ProductCell(
                                pObj: pObj,
                                width: .infinity,
                                didTapProduct: {
                                    path.append(AppRoute.productDetail(pObj))
                                },
                                didAddCart: {
                                    Task {
                                        await cartVM.addProductToCart(prodId: pObj.id, qty: 1)
                                    }
                                }
                            )
                        }
                        
                    }
                    .padding(.vertical, 10)
                    .padding(.bottom, .bottomInsets + 60)
                }
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, 20)
            
            SpinnerView(isLoading: $itemsVM.isLoading)
            
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if cartVM.showPopup || itemsVM.showPopup {
                StatusPopupView(
                    type: cartVM.showPopup ? cartVM.popupType : itemsVM.popupType,
                    messageKey: LocalizedStringKey(cartVM.showPopup ? cartVM.popupMessageKey : itemsVM.popupMessageKey),
                    buttonKey: "ok_button"
                ) {
                    withAnimation(.easeInOut) {
                        if cartVM.showPopup { cartVM.showPopup = false }
                        if itemsVM.showPopup { itemsVM.showPopup = false }
                    }
                }
                .transition(.scale(scale: 0.9).combined(with: .opacity))
                .zIndex(1)
            }
        }
        .animation(.easeInOut, value: cartVM.showPopup || itemsVM.showPopup)
    }
}

#Preview {
    ExploreItemView(path: .constant(NavigationPath()), itemsVM: ExploreItemViewModel(cObj: CategoryModel(id: 1, name: "Frash Fruits & Vegetable", image: "http://localhost:3001/img/category/20230726155407547qM5gSxkrCh.png", colorHex: "53B175")))
}
