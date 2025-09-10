//
//  DelieryAddressView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/9/25.
//

import SwiftUI

struct DelieryAddressView: View {
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
                    Spacer()
                    
                    Text("delivery_address".localized)
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

            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    DelieryAddressView()
}
