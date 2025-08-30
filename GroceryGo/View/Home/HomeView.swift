//
//  HomeView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var path: NavigationPath
    @StateObject var homeVM = HomeViewModel.shared
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    Image("color_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                    
                    Text(Globs.AppName)
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundStyle(.primaryApp)
                        .padding(.bottom, 10)
                    
//                    HStack {
//                        
//                        HStack {
//                            Image("location")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 16, height: 16)
//                            
//                            Text("Viet Nam, HCM")
//                                .font(.customfont(.semibold, fontSize: 18))
//                                .foregroundStyle(.darkGray)
//                        }
//                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                        
//                        Image(systemName: "globe")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 16, height: 16)
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
//                    }
//                    .padding(.horizontal ,20)
//                    
                    
                    HomeTopBar()
                    
                    SearchTextField(placeholder: "search_store", txt: $homeVM.txtSearch)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    

                }
                .padding(.top, .topInsets)
                
                
                Image("banner_top")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 115)
                    .padding(.horizontal, 20)
                
                SectionTitleAll(title: "exclusive_offer", titleAll: "see_all") {
                    
                }
                .padding(.horizontal, 20)
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.offerArr, id: \.id) { pObj in
                            ProductCell(
                                pObj: pObj,
                                didTapProduct: {
                                    path.append(AppRoute.productDetail(pObj))
                                },
                                didAddCart: {
                                    // add to cart
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                
                
                SectionTitleAll(title: "best_selling", titleAll: "see_all") {
                    
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.bestArr, id: \.id) { pObj in
                            ProductCell(
                                pObj: pObj,
                                didTapProduct: {
                                    path.append(AppRoute.productDetail(pObj))
                                },
                                didAddCart: {
                                    // add to cart
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                
                SectionTitleAll(title: "groceries", titleAll: "see_all") {
                    
                }
                .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        
                        ForEach(homeVM.typeArr, id: \.id) { tObj in
                            CategoryCell(tObj: tObj) {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                .padding(.bottom, 8)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.listArr, id: \.id) { pObj in
                            ProductCell(
                                pObj: pObj,
                                didTapProduct: {
                                    path.append(AppRoute.productDetail(pObj))
                                },
                                didAddCart: {
                                    // add to cart
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                .padding(.bottom, 15)
            }
            .padding(.bottom, .bottomInsets + 60)
            
            SpinnerView(isLoading: $homeVM.isLoading)
            
        }
        .onAppear {
            homeVM.fetchData()
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
        .alert(isPresented: $homeVM.showError) {
            
            Alert(title: Text(Globs.AppName), message: Text(homeVM.errorMessage), dismissButton: .default(Text("ok_button".localized)))
        }
        
        
    }
    
}

#Preview {
    HomeView(path: .constant(NavigationPath()))
}
