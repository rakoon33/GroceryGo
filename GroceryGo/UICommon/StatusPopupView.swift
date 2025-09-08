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

    var defaultTitleKey: LocalizedStringKey {
        switch self {
        case .success: return "popup_success_title"   // "Success" | "Thành công"
        case .error:   return "popup_error_title"     // "Error"   | "Lỗi"
        }
    }

    var iconName: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error:   return "xmark.octagon.fill"
        }
    }

    var iconColor: Color {
        switch self {
        case .success: return .green
        case .error:   return .red
        }
    }
}

struct StatusPopupView: View {
    let type: PopupType
    let messageKey: LocalizedStringKey
    let buttonKey: LocalizedStringKey
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: type.iconName)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .foregroundColor(type.iconColor)

                Text(messageKey)
                    .font(.customfont(.semibold, fontSize: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(.horizontal, 20)

                Button(action: onDismiss) {
                    Text(buttonKey)
                        .font(.customfont(.bold, fontSize: 14))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(type.iconColor)
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

#Preview {
    StatusPopupView(type: .success, messageKey: "success_message", buttonKey: "ok_button") {
        
    }
}
