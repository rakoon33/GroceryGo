//
//  ExploreView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

struct ExploreView: View {
    
    @Binding var path: NavigationPath
    @State var txtSearch: String = ""
    @StateObject var exploreVM = ExploreViewModel.shared
    
    var columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Text("find_products".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                }
                .padding(.top, .topInsets)
                .background(Color.white)
                
                SearchTextField(placeholder: "Search store", txt: $txtSearch)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(exploreVM.listArr, id: \.id) {
                            cObj in
                            ExploreCategoryCell(cObj: cObj)
                            {
                               
                            }
                                .aspectRatio(0.95, contentMode: .fill)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .padding(.bottom, .bottomInsets + 60)
                }
                
                Spacer()
            }
            
            SpinnerView(isLoading: $exploreVM.isLoading)
        }
        .onAppear {
            exploreVM.fetchExploreData()
        }
        .alert(isPresented: $exploreVM.showError) {
            
            Alert(title: Text(Globs.AppName), message: Text(exploreVM.errorMessage), dismissButton: .default(Text("ok_button".localized)))
        }
        .ignoresSafeArea()
        .toolbar(.hidden, for: .navigationBar)
    }
    
}

#Preview {
    ExploreView(path: .constant(NavigationPath()))
}
