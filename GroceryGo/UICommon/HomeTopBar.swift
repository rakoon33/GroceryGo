struct HomeTopBar: View {
    @StateObject private var localization = LocalizationManager.shared
    @State private var showLanguageSheet = false
    
    var body: some View {
        HStack {
            HStack {
                Image("location")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text("Viet Nam, HCM")
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundStyle(.darkGray)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Button {
                showLanguageSheet.toggle()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "globe")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    // hiện mã ngôn ngữ hiện tại (EN / VI)
                    Text(localization.currentLanguage.uppercased())
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundStyle(.darkGray)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSelectionView()
        }
    }
}
