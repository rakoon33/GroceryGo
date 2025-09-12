//
//  FavouriteView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 23/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    @StateObject var favVM = FavouriteViewModel.shared
    var body: some View {
        ZStack {
            
            ScrollView {
                LazyVStack {
                    ForEach(favVM.listArr, id: \.id, content: {
                        fObj in
                        
                        FavouriteRow(fObj: fObj) {
                            navigationState.navigate(to: .productDetail(fObj.product))
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
            
        }
        .onAppear {
            Task {
                await favVM.fetchFavouriteList()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    FavouriteView()
}
