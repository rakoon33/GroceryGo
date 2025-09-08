import SwiftUI

struct ToastPopupView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.customfont(.medium, fontSize: 16))
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .shadow(radius: 4)
    }
}