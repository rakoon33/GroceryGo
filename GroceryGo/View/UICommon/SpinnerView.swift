//
//  SpinnerView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

struct SpinnerView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        if isLoading {
            ZStack {
                // Làm mờ nền
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                
                // Spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .darkGray))
                    .scaleEffect(1.4, anchor: .center)
                    .padding()
              
            }
            .transition(.opacity) 
            .animation(.easeInOut, value: isLoading)
        }
    }
}

#Preview {
    SpinnerView(isLoading: .constant(true))
}
