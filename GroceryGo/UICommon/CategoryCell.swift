//
//  CategoryCell.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CategoryCell: View {
    @State var  tObj: TypeModel = TypeModel()

    var didAddCart: (()->())?
    
    
    var body: some View {
        HStack {
            
            WebImage(url: URL(string: tObj.image))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            Text(tObj.name)
                .font(.customfont(.bold, fontSize: 16))
                .foregroundStyle(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            
        }
        .padding(15)
        .frame(width: 250, height: 100)
        .background(tObj.color.opacity(0.3))
        .cornerRadius(10)
    }
}

#Preview {
    CategoryCell(tObj: TypeModel(id: 1, name: "Pulses", image: "http://localhost:3001/img/type/202307261610181018aVOpgmY1W1.png", colorHex: "F8A44C")) {
    }
}
