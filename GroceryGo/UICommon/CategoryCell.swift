//
//  CategoryCell.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//

import SwiftUI

struct CategoryCell: View {
    
    @State var color: Color = Color.yellow
    var didAddCart: (()->())?
    
    
    var body: some View {
        HStack {
            Image("pulses")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            Text("Pulses")
                .font(.customfont(.bold, fontSize: 16))
                .foregroundStyle(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            
        }
        .padding(15)
        .frame(width: 250, height: 100)
        .background(color.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    CategoryCell()
}
