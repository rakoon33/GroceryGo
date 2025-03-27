//
//  RoundButton.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/3/25.
//

import SwiftUI

struct RoundButton: View {
    var body: some View {
        
        @State var title: String = "Title"
        var didTap: (()->())?
        
        Button {
            didTap?()
        } label: {
            Text(title)
                .font(.customfont(.semibold, fontSize: 18))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
        .background(Color.primaryApp)
        .cornerRadius(20)

    }
}

#Preview {
    RoundButton()
        .padding(20)
}
