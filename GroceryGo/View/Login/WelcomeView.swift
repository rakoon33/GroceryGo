//
//  WelcomeView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/3/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationStack {
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
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 30)
                   
                    NavigationLink {
                        SignInView()
                    } label: {
                        RoundButton(title: "Get Started") {
                        }
                    }
                                        
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
}

#Preview {
    WelcomeView()
}
