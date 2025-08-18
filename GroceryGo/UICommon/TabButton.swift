//
//  TabButton.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/8/25.
//

import SwiftUI

struct TabButton: View {
    
    @State var title: String = "Title"
    @State var icon: String = "store_tab"
    
    var isSelected: Bool = false
    var didSelected: (()->())?
    
    
    var body: some View {
        Button {
            didSelected?()
        } label: {
            VStack{
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                
                Text(title)
                    .font(.customfont(.semibold, fontSize: 14))
   
                Rectangle()
                    .fill(isSelected ? Color.primaryApp : Color.clear)
                    .frame(height: 3)
                    .cornerRadius(2)
                    .padding(.top, 2)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .foregroundColor(isSelected ? .primaryApp : .primaryText)
        

    }
}

#Preview {
    TabButton()
}
