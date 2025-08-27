struct LanguageSelectionView: View {
    @StateObject private var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                ForEach(localization.supportedLanguages, id: \.self) { lang in
                    Button {
                        localization.setLanguage(lang)
                        dismiss()
                    } label: {
                        HStack {
                            Text(lang == "vi" ? "Tiếng Việt" : "English")
                            Spacer()
                            if lang == localization.currentLanguage {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .navigationTitle("select_language".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
