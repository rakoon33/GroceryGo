//
//  FavouriteCell.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 24/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct FavouriteRow: View {
    var fObj: FavouriteModel
    var didTapProduct: (() -> Void)?
    var body: some View {
        Button {
            didTapProduct?()
        } label: {
            VStack {
                HStack {
                    WebImage(url: URL(string: fObj.product.image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                    
                    VStack(spacing: 4) {
                        Text(fObj.product.name)
                            .font(.customfont(.bold, fontSize: 16))
                            .foregroundStyle(.primaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(fObj.product.unitValue)\(fObj.product.unitName), price")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundStyle(.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("$\(fObj.product.offerPrice ?? fObj.product.price, specifier: "%.2f")")
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundStyle(.primaryText)
                    
                    Image("next")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color.secondaryText)
                        .frame(width: 15, height: 15)
                    
                }
                Divider()
            }
        }
    }
}

#Preview {
    FavouriteRow(
        fObj: FavouriteModel(
            id: 11,
            product: ProductModel(
                id: 6,
                catId: 1,
                brandId: 1,
                typeId: 1,
                name: "Red Apple",
                detail: "Apples contain key nutrients...",
                unitName: "kg",
                unitValue: "1",
                nutritionWeight: "182g",
                offerPrice: 1.99,
                startDate: nil,
                endDate: nil,
                price: 1.99,
                image: "http://localhost:3001/img/product/202307310951365136W6nJvPCdzQ.png",
                catName: "Frash Fruits & Vegetable",
                typeName: "Pulses",
                isFav: true
            )
        )
    )
    .padding(20)
}
