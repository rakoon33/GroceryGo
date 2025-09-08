//
//  PopupType.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//


import SwiftUI

enum PopupType {
    case success
    case error
}

struct StatusPopupView: View {
    let type: PopupType
    let title: String
    let message: String
    let buttonTitle: String
    var onDismiss: () -> Void

    private var iconName: String {
        switch type {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.octagon.fill"
        }
    }

    private var iconColor: Color {
        switch type {
        case .success: return .green
        case .error: return .red
        }
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: iconName)
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(iconColor)

                Text(title)
                    .font(.title2).bold()
                    .foregroundColor(.black)

                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)

                Button(action: onDismiss) {
                    Text(buttonTitle)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(iconColor)
                        .cornerRadius(8)
                }
                .padding(.horizontal, 20)
            }
            .padding(24)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding(40)
        }
    }
}
