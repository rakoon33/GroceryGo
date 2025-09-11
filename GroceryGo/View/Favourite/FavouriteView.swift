//
//  FavouriteView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 23/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteView: View {
    
    @Binding var path: NavigationPath
    @StateObject var favVM = FavouriteViewModel.shared
    var body: some View {
        ZStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(favVM.listArr, id: \.id, content: {
                        fObj in
                        
                        FavouriteRow(fObj: fObj) {
                            path.append(AppRoute.productDetail(fObj.product))
                        }
                    })
                }
                .padding(20)
                .padding(.top, .topInsets + 46)
                .padding(.bottom, .bottomInsets + 60)
            }
            
            VStack {
                HStack {
                    Spacer()
                    
                    Text("product_detail_favorites".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                }
                .padding(.top, .topInsets)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2)
                
                Spacer()
                
                RoundButton(title: "add_all_to_cart".localized)
                    .padding(20)
                    .padding(.bottom, .bottomInsets + 80)
            }
            
            SpinnerView(isLoading: $favVM.isLoading)
            
        }
        .onAppear {
            Task {
                await favVM.fetchFavouriteList()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if favVM.showPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.6), value: favVM.showPopup)

                    StatusPopupView(
                        type: favVM.popupType,
                        messageKey: LocalizedStringKey(favVM.popupMessageKey),
                        buttonKey: "ok_button"
                    ) {
                        withAnimation(.easeInOut(duration: 0.6)) {
                            favVM.showPopup = false
                        }
                    }
                    .transition(.scale(scale: 0.9).combined(with: .opacity))
                    .animation(
                        .spring(response: 0.7, dampingFraction: 0.9, blendDuration: 0.3),
                        value: favVM.showPopup
                    )
                }
                .zIndex(1)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    FavouriteView(path: .constant(NavigationPath()))
}
