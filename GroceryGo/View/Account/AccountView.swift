import SwiftUI

struct AccountView: View {
    @StateObject private var session = SessionManager.shared
    
    var body: some View {
        VStack {
            if let user = session.user {
                Text("Hello, \(user.username)")
                    .font(.headline)
                    .padding(.bottom, 20)
                
                Button(action: {
                    session.logout()
                }) {
                    Text("Logout")
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                }
            } else {
                Text("Not logged in")
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    AccountView()
}
