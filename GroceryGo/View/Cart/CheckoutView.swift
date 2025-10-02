//
//  CheckoutView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/9/25.
//

import SwiftUI

struct CheckoutView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    
    @Binding var isShow: Bool
    
    @StateObject var cartVM = CartViewModel.shared
    
    var body: some View {
        VStack {
            
            Spacer()
            
            VStack {
                HStack {
                    Text("Checkout")
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    
                    Spacer()
                    
                    Button {
                        $isShow.wrappedValue = false
                    } label: {
                        Image("close")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                .padding(.top, 30)
                
                Divider()
                
                VStack {
                    
                    HStack {
                        Text("Delivery Type")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.secondaryText)
                            .frame(height: 46)
                        
                        Spacer()
                        
                        Picker("", selection: $cartVM.deliveryType) {
                            Text("Delivery").tag(1)
                            Text("Collection").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 180)
                    }
                    
                    Divider()
                    
                    if(cartVM.deliveryType == 1) {
                        HStack {
                            Text("Delivery")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.secondaryText)
                                .frame(height: 46)
                            
                            Spacer()
                            
                            Text("Delivery")
                                .font(.customfont(.semibold, fontSize: 18))
                                .foregroundColor(.primaryText)
                                .frame(height: 46)
                            
                            Image("next")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.primaryText)
                            
                        }
                        
                        Divider()
                    }
                    
                    HStack {
                        Text("Payment Type")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.secondaryText)
                            .frame(height: 46)
                        
                        Spacer()
                        
                        Picker("", selection: $cartVM.paymentType) {
                            Text("COD").tag(1)
                            Text("Online").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .frame(width: 150)
                        
                    }
                    
                    Divider()
                    
                    if(cartVM.paymentType == 2) {
                        HStack {
                            Text("Payment")
                                .font(.customfont(.bold, fontSize: 18))
                                .foregroundColor(.secondaryText)
                                .frame(height: 46)
                            
                            Spacer()
                            
                            Image("master")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 20)
                            
                            Text("Select")
                                .font(.customfont(.semibold, fontSize: 18))
                                .foregroundColor(.primaryText)
                                .frame(height: 46)
                            
                            Image("next")
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.primaryText)
                            
                        }
                        
                        Divider()
                    }
                    
                    HStack {
                        Text("Promo Code")
                            .font(.customfont(.bold, fontSize: 18))
                            .foregroundColor(.secondaryText)
                            .frame(height: 46)
                        
                        Spacer()
                        

                        Text("Pick Discount")
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundColor(.primaryText)
                            .frame(height: 46)
                        
                        Image("next")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.primaryText)
                        
                    }
                    
                    Divider()
                }
                
                VStack {
                    
                    HStack {
                        Text("Total")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.secondaryText)
                        
                        Spacer()
                        
                        Text("$ 4.26")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.secondaryText)
                    }
                    
                    HStack {
                        Text("Delivery Cost")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.secondaryText)
                        
                        Spacer()
                        
                        Text("+ $ 2.00")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.secondaryText)
     
                    }
                    
                    HStack {
                        Text("Discount")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.secondaryText)
                        
                        Spacer()
                        
                        Text("- $ 0.80")
                            .font(.customfont(.semibold, fontSize: 16))
                            .foregroundColor(.red)
     
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 15)
                    
                HStack {
                    Text("Final total")
                        .font(.customfont(.bold, fontSize: 18))
                        .foregroundColor(.secondaryText)
                        .frame(height: 46)
                    
                    Spacer()
                    

                    Text("$ 3.29")
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundColor(.primaryText)
                        .frame(height: 46)
                    
                    Image("next")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primaryText)
                    
                }
                
                Divider()
                
                VStack {
                    
                    HStack {
                        Text("signup_terms_prefix".localized)
                            .font(.customfont(.semibold, fontSize: 14))
                            .foregroundColor(.secondaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    }
                    
                    HStack {
                        Text("signup_terms_title".localized)
                            .font(.customfont(.semibold, fontSize: 14))
                            .foregroundColor(.primaryApp)
                
                        Text("signup_and".localized)
                            .font(.customfont(.semibold, fontSize: 14))
                            .foregroundColor(.secondaryText)

                        Text("signup_privacy_title".localized)
                            .font(.customfont(.semibold, fontSize: 14))
                            .foregroundColor(.primaryApp)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                }
                .padding(.vertical, .screenWidth * 0.03)
                
                RoundButton(title: "Place Order") {
                    
                }
                .padding(.bottom, .bottomInsets + 15)
                    
            }
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(20, corner: [.topLeft, .topRight])
        }
        
    }
}

#Preview {
    
    @State var isShow: Bool = false
    
    CheckoutView(isShow: $isShow)
}
