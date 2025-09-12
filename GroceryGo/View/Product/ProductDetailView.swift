//
//  ProductDetailView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 22/8/25.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProductDetailView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    @StateObject var detailVM: ProductDetailViewModel = ProductDetailViewModel(prodObj: ProductModel())
    @StateObject var favVM = FavouriteViewModel.shared
    @StateObject var cartVM = CartViewModel.shared
    
    var body: some View {
        ZStack {
            
            ScrollView {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(hex: "F2F2F2"))
                        .frame(width: .screenWidth, height: .screenWidth * 0.8)
                        .cornerRadius(20, corner: [.bottomLeft, .bottomRight])
                    
                    WebImage(url: URL(string: detailVM.pObj.image))
                        .resizable()
                        .indicator(.activity)
                        .transition(.fade(duration: 0.5))
                        .scaledToFit()
                        .frame(width: .screenWidth * 0.8, height: .screenWidth * 0.8)
                    
                }
                .frame(width: .screenWidth, height: .screenWidth * 0.8)
                
                VStack {
                    HStack {
                        Text(detailVM.pObj.name)
                            .font(.customfont(.bold, fontSize: 24))
                            .foregroundColor(.primaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            Task {
                                await detailVM.toggleFavourite()
                            }
                        } label: {
                            Image(detailVM.isFav ? "favorite" : "not_fav")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                        
                    }
                    .foregroundColor(detailVM.isFav ? .red : .secondaryText)
                    
                    Text("\(detailVM.pObj.unitValue)\(detailVM.pObj.unitName), Price")
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundStyle(.secondaryText)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        
                        Button {
                            detailVM.addSubQTY(isAdd: false)
                        } label: {
                            Image("subtack")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(10)
                        }
                        
                        Text("\(detailVM.qty)")
                            .font(.customfont(.bold, fontSize: 24))
                            .foregroundColor(.primaryText)
                            .multilineTextAlignment(.center)
                            .frame(width: 45, height: 45, alignment: .center)
                            .overlay {
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.placeholder.opacity(0.8), lineWidth: 1)
                            }
                        
                        Button {
                            detailVM.addSubQTY(isAdd: true)
                        } label: {
                            Image("add_green")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .padding(10)
                        }
                        
                        Spacer()
                        
                        Text("$\(detailVM.pObj.offerPrice ?? detailVM.pObj.price * Double(detailVM.qty), specifier: "%.2f")")
                            .font(.customfont(.bold, fontSize: 28))
                            .foregroundColor(.primaryText)
                        
                    }
                    .padding(.vertical, 8)
                    
                    Divider()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                VStack {
                    HStack {
                        Text("product_detail_title".localized)
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.primaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            withAnimation() {
                                detailVM.showDetail()
                            }
                        } label: {
                            Image(detailVM.isShowDetail ? "detail_open" : "next")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(15)
                            
                        }
                        .foregroundColor(Color.secondaryText)
                    }
                    
                    if(detailVM.isShowDetail) {
                        Text("\(detailVM.pObj.detail)")
                            .font(.customfont(.medium, fontSize: 13))
                            .foregroundStyle(.secondaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)
                    }
                    
                    Divider()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                VStack {
                    HStack {
                        Text("product_detail_nutritions".localized)
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.primaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(detailVM.pObj.nutritionWeight)")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.primaryText)
                            .padding(8)
                            .background(Color.placeholder.opacity(0.5))
                            .cornerRadius(5)
                        
                        
                        Button {
                            withAnimation() {
                                detailVM.showNutritions()
                            }
                        } label: {
                            Image(detailVM.isShowNutrition ? "detail_open" : "next")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 15)
                                .padding(15)
                            
                        }
                        .foregroundColor(Color.secondaryText)
                    }
                    
                    if(detailVM.isShowNutrition) {
                        LazyVStack {
                            
                            ForEach(detailVM.nutritionArr, id: \.id) { nObj in
                                HStack {
                                    Text(nObj.nutritionName)
                                        .font(.customfont(.semibold, fontSize: 15))
                                        .foregroundColor(.secondaryText)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    
                                    Text(nObj.nutritionValue)
                                        .font(.customfont(.semibold, fontSize: 15))
                                        .foregroundColor(.primaryText)
                                }
                                
                                Divider()
                            }
                            .padding(.vertical, 0)
                        }
                        .padding(.horizontal, 10)
                    }
                    
                    Divider()
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                HStack {
                    Text("product_detail_review".localized)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.primaryText)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 2) {
                        
                        
                        ForEach(1...5, id: \.self) { index in
                            if detailVM.pObj.avgRating >= Double(index) {
                                Image(systemName: "star.fill") // full star
                                    .foregroundColor(.orange)
                                    .font(.system(size: 15))
                            } else if detailVM.pObj.avgRating + 0.5 >= Double(index) {
                                Image(systemName: "star.leadinghalf.filled") // half star
                                    .foregroundColor(.orange)
                                    .font(.system(size: 15))
                            } else {
                                Image(systemName: "star") // empty star
                                    .foregroundColor(.orange)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    
                    Button {
                        
                    } label: {
                        Image("next")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(15)
                        
                    }
                    .foregroundColor(Color.secondaryText)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                RoundButton(title: "add_to_basket".localized) {
                    Task {
                        await cartVM.addProductToCart(prodId: detailVM.pObj.id, qty: detailVM.qty)
                        
                        detailVM.qty = 1
                    }
                }
                .padding(20)
            }
            
            VStack {
                HStack {
                    Button {
                        navigationState.removeLast()
                        
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                    
                    Button {
                    } label: {
                        Image("share")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                }
                
                Spacer()
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, 20)
            
        }
        .background(.systemBackground)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()

    }
    
}

#Preview {
    ProductDetailView(detailVM: ProductDetailViewModel(prodObj: ProductModel(id: 5, catId: 1, brandId: 1, typeId: 1, name: "Organic Banana", detail: "banana, fruit of the genus Musa, of the family Musacee, one of the most important fruit crops of the world. The banana is grown in the tropics, and, though it is most widely consumed in those regions, it is valued worldwide for its flavour, nutritional value, and availability throughout the year", unitName: "pcs", unitValue: "7", nutritionWeight: "200g", offerPrice: 2.99, startDate: Date(), endDate: Date(), price: 2.99, image: "http://localhost:3001/img/product/202307310947354735xuruflIucc.png", catName: "Frash Fruits & Vegetable", typeName: "Pulses", isFav: false, avgRating: 5.0)))
}
