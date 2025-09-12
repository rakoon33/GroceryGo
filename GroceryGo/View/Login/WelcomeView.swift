//
//  WelcomeView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/3/25.
//

import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    
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
                
                Text("welcome_title".localized)
                    .font(.customfont(.semibold, fontSize: 48))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("welcome_subtitle".localized)
                    .font(.customfont(.medium, fontSize: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                
                RoundButton(title: "welcome_get_started".localized) {
                    UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
                    navigationState.navigate(to: .signin)
                }
                
                Spacer()
                    .frame(height: 60)
            }
            .padding(.horizontal, 20)
        }
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
    
}

#Preview {
    WelcomeView()
}
