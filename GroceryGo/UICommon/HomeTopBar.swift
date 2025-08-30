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
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        HStack {
            HStack {
                Image("location")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                
                Text("\(locationManager.currentCity), \(locationManager.currentCountry)")
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundStyle(.darkGray)
                    .lineLimit(1) // chỉ 1 dòng
                    .truncationMode(.tail) // cắt cuối nếu quá dài

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
                        .stroke(Color.darkGray, lineWidth: 1) // viền màu xám
                )
            }
            .foregroundStyle(.darkGray)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)

        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showLanguageSheet) {
            LanguageSelectionView()
        }
    }
}


#Preview {
    HomeTopBar()
}
