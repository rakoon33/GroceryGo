//
//  SectionTitleAll.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 20/8/25.
//

import SwiftUI

struct SectionTitleAll: View {
    
    @EnvironmentObject var localization: LocalizationManager
    
    @State var title: String = "Title"
    @State var titleAll: String = "View All"
    
    
    var didTap: (()->())?
    var body: some View {
        HStack {
            Text(title.localized)
                .font(.customfont(.semibold, fontSize: 24))
                .foregroundStyle(.primaryText)
            
            Spacer()
            
            Text(titleAll.localized)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundStyle(.primaryApp)
        }
        .frame(height: 40)
    }
}

#Preview {
    SectionTitleAll()
        .padding(20)
}
