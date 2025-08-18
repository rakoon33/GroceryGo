//
//  MainTabView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 15/8/25.
//

import SwiftUI

struct MainTabView: View {
    
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            VStack {

                
                HStack {
                    Button {
                        MainViewModel.shared.isUserLogin = false
                        
                    } label: {
                        Text("Logout")
                        
                    }
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    MainTabView(path: .constant(NavigationPath()))
}
