//
//  CartItemRow.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct CartItemRow: View {
    var cObj: CartItemModel
    var didTapProduct: (() -> Void)?
    
    var body: some View {
        Button {
            didTapProduct?()
        } label: {
            VStack {
                HStack {
                    WebImage(url: URL(string: cObj.image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                    
                    VStack(spacing: 4) {

                        HStack {
                            Text(cObj.name)
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundStyle(.primaryText)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
                                Task {
                                    await CartViewModel.shared.removeFromCart(cartId: cObj.id, prodId: cObj.prodId)
                                }
                            } label: {
                                Image("close")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                                
                                    
                            }
                        }
                        
                        Text("\(cObj.unitValue)\(cObj.unitName), price")
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundStyle(.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)
                        
                        HStack {
                            
                            Button {
                                Task {
                                    await CartViewModel.shared.updateCartQty(cartId: cObj.id, prodId: cObj.prodId, newQty: cObj.qty - 1)
                                }
                            } label: {
                                Image("subtack")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(10)
                            }
                            .padding(2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.placeholder.opacity(0.8), lineWidth: 1)
                            }
                            
                            Text("\(cObj.qty)")
                                .font(.customfont(.bold, fontSize: 24))
                                .foregroundColor(.primaryText)
                                .multilineTextAlignment(.center)
                                .frame(width: 45, height: 45, alignment: .center)

                            
                            Button {
                                Task {
                                    await CartViewModel.shared.updateCartQty(cartId: cObj.id, prodId: cObj.prodId, newQty: cObj.qty + 1)
                                }
                            } label: {
                                Image("add_green")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(10)
                            }
                            .padding(2)
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.placeholder.opacity(0.8), lineWidth: 1)
                            }
                            
                            Spacer()
                            
                            Text("$\(cObj.offerPrice ?? cObj.price, specifier: "%.2f")")
                                .font(.customfont(.semibold, fontSize: 20))
                                .foregroundStyle(.primaryText)
                            
                        }
                    }
                    
                }
                Divider()
            }
        }
    }
}

#Preview {
    CartItemRow(
        cObj: CartItemModel(
            id: 36,
            prodId: 5,
            userId: 2,
            qty: 1,
            catId: 1,
            brandId: 1,
            typeId: 1,
            brandName: "bigs",
            name: "Organic Banana",
            detail: "Banana, fruit of the genus Musa...",
            unitName: "pcs",
            unitValue: "7",
            nutritionWeight: "200g",
            offerPrice: 2.99,
            price: 2.99,
            itemPrice: 2.99,
            totalPrice: 2.99,
            image: "http://localhost:3001/img/product/202307310947354735xuruflIucc.png",
            catName: "Frash Fruits & Vegetable",
            typeName: "Pulses",
            isFav: true,
            avgRating: 0
        )
    )
    .padding(20)
}
