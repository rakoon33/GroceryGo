//
//  LanguageSelectionView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//
import SwiftUI

struct LanguageSelectionView: View {
    @StateObject private var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss
    
    private let languageNames: [String: String] = [
        "en": "English",
        "vi": "Tiếng Việt"
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                ForEach(localization.supportedLanguages, id: \.self) { lang in
                    Button {
                        localization.setLanguage(lang)
                        dismiss()
                    } label: {
                        HStack(spacing: 12) {
                            // 🇺🇸 Cờ
                            Image("flag_\(lang)")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28, height: 20)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            
                            // Tên ngôn ngữ
                            Text(languageNames[lang] ?? lang.uppercased())
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            if lang == localization.currentLanguage {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.blue)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(lang == localization.currentLanguage ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                        )
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("select_language".localized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
