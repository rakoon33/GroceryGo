//
//  WelcomeView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/3/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image("welcom_bg")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight)
            
            VStack {
                
                Spacer()
                
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                Text("Welcome\nto our shop")
                    .font(.customfont(.semibold, fontSize: 48))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Fast grocery delivery at your convenience.")
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .padding(.bottom, 20)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 20)
               
                Button {
                    print()
                } label: {
                    Text("Get Started")
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                .background(Color.primaryApp)
                .cornerRadius(20)
               
                Spacer()
                    .frame(height: 60)
            }
            .padding(.horizontal, 20)
        }
        .navigationTitle("")
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden)
        .navigationBarHidden(true)
        .ignoresSafeArea()
        
        
    }
}

#Preview {
    WelcomeView()
}
