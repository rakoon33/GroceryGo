//
//  DelieryAddressView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/9/25.
//

import SwiftUI

struct DelieryAddressView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            
            ScrollView {
                LazyVStack {
                    
                }
                .padding(20)
                .padding(.top, .topInsets + 46)
                .padding(.bottom, .bottomInsets + 60)
            }
            
            VStack {
                HStack {
                    
                    Button {
                        path.removeLast()
                    } label: {
                        Image("back")
                            .resizable()
                            .frame(width: 15, height: 15)
                    }
                    
                    Spacer()
                    
                    Text("delivery_address".localized)
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2), radius: 2)
                
                Spacer()
            
            }
            
        }
        .onAppear {
            Task {

            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    DelieryAddressView(path: .constant(NavigationPath()))
}
