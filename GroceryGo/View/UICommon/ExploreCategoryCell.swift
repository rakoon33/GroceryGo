//
//  ExploreCategory.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 25/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ExploreCategoryCell: View {
    @State var cObj: CategoryModel = CategoryModel()

    var didTapCategory: (()->())?
    
    
    var body: some View {
        Button {
            didTapCategory?()
        } label: {
            VStack {
                
                WebImage(url: URL(string: cObj.image))
                    .resizable()
                    .indicator(.activity)
                    .transition(.fade(duration: 0.5))
                    .scaledToFit()
                    .frame(width: 120, height: 90)
                
                Spacer()
                
                Text(cObj.name)
                    .font(.customfont(.bold, fontSize: 16))
                    .foregroundStyle(.primaryText)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                Spacer()
                
            }
            .padding(15)

            .background(cObj.color.opacity(0.3))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(cObj.color, lineWidth: 1)
            )
        }
    }
}

#Preview {
    ExploreCategoryCell(cObj: CategoryModel(id: 1, name: "Pulses", image: "http://localhost:3001/img/type/202307261610181018aVOpgmY1W1.png", colorHex: "F8A44C")) {
    }
    .padding(20)
}
