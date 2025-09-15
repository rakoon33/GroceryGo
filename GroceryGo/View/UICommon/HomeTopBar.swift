//
//  HomeTopBar.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//
import SwiftUI

private let languageNames = [
    "en": "English",
    "vi": "Tiếng Việt"
]

struct HomeTopBar: View {
    @StateObject private var localization = LocalizationManager.shared
    @State private var showLanguageSheet = false
    
    @State private var city: String = ""
    @State private var country: String = ""
    
    var body: some View {
        HStack {
            HStack {
                Image("location")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text("\(city), \(country)")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.darkGray)
                    .lineLimit(1)
                    .truncationMode(.tail)
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
                    
                    Text(languageNames[localization.currentLanguage] ?? localization.currentLanguage.uppercased())
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundStyle(.darkGray)
                    
                    Image("detail_open")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 10, height: 10)
                }
                .padding(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(Color.darkGray, lineWidth: 1)
                )
            }
            .foregroundStyle(.darkGray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSelectionView()
        }
        .task {
            do {
                let result = try await LocationManager.shared.requestCityAndCountryOnce()
                city = result.city
                country = result.country
            } catch {
                print("Location error: \(error)")
            }
        }
    }
}

#Preview {
    HomeTopBar()
}
