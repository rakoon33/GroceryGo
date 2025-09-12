//
//  SignInView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 28/3/25.
//

import SwiftUI
import CountryPicker

struct SignInView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    
    @State var txtMobile: String = ""
    @State var isShowPicker: Bool = false
    @State var countryObj: Country?
    
    
    var body: some View {
        ZStack(alignment: .top) {
            
            Image("bottom_bg")
                .resizable()
                .scaledToFill()
                .frame(width: .screenWidth, height: .screenHeight)
            
            VStack {
                
                Image("sign_in_top")
                    .resizable()
                    .scaledToFill()
                    .frame(width: .screenWidth, height: .screenWidth)
                
                Spacer()
            }
            
            ScrollView {
                
                VStack(alignment: .leading) {
                    Text("sign_in_title".localized)
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.primaryText)
                        .padding(.bottom, 25)
                      
                    
                    HStack {
                        Button {
                            isShowPicker = true
                        } label: {
                            
                            if let countryObj = countryObj {
                                
                                Text("\(countryObj.isoCode.getFlag())")
                                    .font(.customfont(.medium, fontSize: 35))
                                    .foregroundColor(.primaryText)
                                
                                Text("+\(countryObj.phoneCode)")
                                    .font(.customfont(.medium, fontSize: 18))
                                    .foregroundColor(.primaryText)
                            }
                            
                        }
                        
                        TextField("sign_in_placeholder_mobile".localized, text: $txtMobile)
                            .frame(minWidth: 0, maxWidth: .infinity)
                        
                    }
                    
                    Text("sign_in_continue_email_login".localized)
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color(hex: "4A66AC"))
                        .cornerRadius(20)
                        .padding(.top, 8)
                        .onTapGesture {
                            navigationState.navigate(to: .login)
                        }
                    
                    Text("sign_in_continue_email_signup".localized)
                        .font(.customfont(.semibold, fontSize: 18))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color.primaryApp)
                        .cornerRadius(20)
                        .onTapGesture {
                            navigationState.navigate(to: .signup)
                        }
                    
                    Divider()
                        .padding(.bottom, 25)
                    
                    Text("sign_in_social_title".localized)
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.textTitle)
                        .multilineTextAlignment(.center)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                        .padding(.bottom, 25)
                    
                    Button {
                        
                    } label: {
                        
                        Image("google_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("sign_in_continue_google".localized)
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                    .background(Color(hex: "5383EC"))
                    .cornerRadius(20)
                    .padding(.bottom, 8)
                    
                    Button {
                     
                    } label: {
                        
                        Image("fb_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text("sign_in_continue_facebook".localized)
                            .font(.customfont(.semibold, fontSize: 18))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                    .background(Color(hex: "4A66AC"))
                    .cornerRadius(20)
                
                }
                .padding(.horizontal, 20)
                .frame(width: .screenWidth, alignment: .leading)
                .padding(.top, .topInsets + .screenWidth * 0.6)
                
            }
            
        }
        
        .sheet(isPresented: $isShowPicker, content: {
            CountryPickerUI(country: $countryObj)
        })
        .onAppear {
            self.countryObj = Country(phoneCode: "84", isoCode: "VN")
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    SignInView()
}

