//
//  ProductCell.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 21/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductCell: View {
    
    @State var pObj: ProductModel
    
    var didAddCart: (()->())?
    
    var body: some View {
        VStack {
            
            
            
            WebImage(url: URL(string: pObj.image))
                .resizable()
                .indicator(.activity)
                .transition(.fade(duration: 0.5))
                .scaledToFit()
                .frame(width: 100, height: 80)
            
            Spacer()
            
            Text(pObj.name)
                .font(.customfont(.bold, fontSize: 16))
                .foregroundStyle(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Text("\(pObj.unitValue)\(pObj.unitName), price")
                .font(.customfont(.medium, fontSize: 14))
                .foregroundStyle(.secondaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack {
                
                Text("$\(pObj.offerPrice ?? pObj.price, specifier: "%.2f")")
                    .font(.customfont(.semibold, fontSize: 18))
                    .foregroundStyle(.primaryText)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button {
                    didAddCart?()
                } label: {
                    Image("add_green")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 15, height: 15)
                        .padding(10)
                    
                }
                .background(Color.primaryApp)
                .frame(width: 30, height: 30)
                .cornerRadius(5)
                
            }
        }
        .padding(15)
        .frame(width: 180, height: 230)
        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.placeholder.opacity(0.5), lineWidth: 1)
        }
    }
}

#Preview {
    ProductCell(pObj: ProductModel(id: 5, catId: 1, brandId: 1, typeId: 1, name: "Organic Banana", detail: "banana, fruit of the genus Musa, of the family Musacee, one of the most important fruit crops of the world. The banana is grown in the tropics, and, though it is most widely consumed in those regions, it is valued worldwide for its flavour, nutritional value, and availability throughout the year", unitName: "pcs", unitValue: "7", nutritionWeight: "200g", offerPrice: 2.99, startDate: Date(), endDate: Date(), price: 2.99, image: "http://localhost:3001/img/product/202307310947354735xuruflIucc.png", catName: "Frash Fruits & Vegetable", typeName: "Pulses", isFav: false, avgRating: 5.0)
    )
}
