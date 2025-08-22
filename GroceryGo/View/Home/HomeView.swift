//
//  HomeView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel.shared
    
    var body: some View {
        
        ZStack {
            ScrollView {
                VStack {
                    Image("color_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25)
                    
                    HStack {
                        Image("location")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                        
                        Text("Viet Nam, HCM")
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundStyle(.darkGray)
                    }
                    
                    SearchTextField(placeholder: "Search store", txt: $homeVM.txtSearch)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .padding(.top, .topInsets)
                
                
                Image("banner_top")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 115)
                    .padding(.horizontal, 20)
                
                SectionTitleAll(title: "Exclusive offer", titleAll: "See all") {
                    
                }
                .padding(.horizontal, 20)
   
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.offerArr, id: \.id) { pObj in
                            ProductCell(pObj: pObj) {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }

                
                SectionTitleAll(title: "Best selling", titleAll: "See all") {
                    
                }
                .padding(.horizontal, 20)
    
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(homeVM.bestArr, id: \.id) { pObj in
                            ProductCell(pObj: pObj) {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                
                SectionTitleAll(title: "Groceries", titleAll: "See all") {
                    
                }
                .padding(.horizontal, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(0...5, id: \.self) { index in
                            CategoryCell(color: Color(hex: "F8A44C")) {
                                
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                }
                .padding(.bottom, 8)
                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    LazyHStack(spacing: 15) {
//                        ForEach(0...5, id: \.self) { index in
//                            ProductCell() {
//                                
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 4)
//                }
//                .padding(.bottom, 15)
            }
        }
        .ignoresSafeArea()
        .alert(isPresented: $homeVM.showError) {
            
            Alert(title: Text(Globs.AppName), message: Text(homeVM.errorMessage), dismissButton: .default(Text("ok_button".localized)))
        }
            
    }
    
}

#Preview {
    HomeView()
}
