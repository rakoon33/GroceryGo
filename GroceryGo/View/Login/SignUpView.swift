//
//  SignUpView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/8/25.
//

import SwiftUI

struct SignUpView: View {
    
    @Binding var path: NavigationPath
    @StateObject var mainVM = MainViewModel.shared;
    
    var body: some View {
        ZStack {
            
            Image("bottom_bg")
                .resizable()
                .scaledToFit()
                .frame(width: .screenWidth, height: .screenHeight)
            
            ScrollView {
                VStack {
                    
                    Image("color_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .padding(.bottom, .screenWidth * 0.1)
                    
                    Text("signup_title".localized)
                        .font(.customfont(.semibold, fontSize: 26))
                        .foregroundColor(.primaryText)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 4)
                    
                    Text("signup_subtitle".localized)
                        .font(.customfont(.semibold, fontSize: 16))
                        .foregroundColor(.secondaryText)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, .screenWidth * 0.1)
                    
                    LineTextField(title: "signup_email_title".localized,
                                  placeholder: "signup_email_placeholder".localized,
                                  txt: $mainVM.txtEmail,
                                  keyboardType: .emailAddress)
                    .padding(.bottom, .screenWidth * 0.07)
                    
                    LineTextField(title: "signup_username_title".localized,
                                  placeholder: "signup_username_placeholder".localized,
                                  txt: $mainVM.txtUsername,
                                  keyboardType: .emailAddress)
                    .padding(.bottom, .screenWidth * 0.07)
                    
                    LineSecureField(title: "signup_password_title".localized,
                                    placeholder: "signup_password_placeholder".localized,
                                    txt: $mainVM.txtPassword,
                                    isShowPassword: $mainVM.isShowPassword)
                    .padding(.bottom, .screenWidth * 0.02)

                    HStack {
                        Text("signup_terms_prefix".localized)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.secondaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                    }
                    
                    HStack {
                        Text("signup_terms_title".localized)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.primaryApp)
                
                        Text("signup_and".localized)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.secondaryText)
   
                        Text("signup_privacy_title".localized)
                            .font(.customfont(.medium, fontSize: 14))
                            .foregroundColor(.primaryApp)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    .padding(.bottom, .screenWidth * 0.02)
                    
                    RoundButton(title: "signup_button".localized) {
                        mainVM.signUp()
                    }
                    .padding(.bottom, .screenWidth * 0.05)
                    
                    
                    
                    HStack {
                        Text("signup_already_have".localized)
                            .font(.customfont(.semibold, fontSize: 14))
                            .foregroundColor(.primaryText)
                        
                        Text("signup_signin".localized)
                            .font(.customfont(.semibold, fontSize: 14))
                            .foregroundColor(.primaryApp)
                    }
                    .onTapGesture {
                        path.append(AppRoute.signin) // Điều hướng sang SignInView
                    }
                    
                    
                    Spacer()
                    
                }
                .padding(.top, .topInsets + 64)
                .padding(.horizontal, 20)
                .padding(.bottom, .bottomInsets)
            }
            
            
            VStack {
                
                HStack {
                    Button {
                        if !path.isEmpty {
                            path.removeLast()
                        }
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.top, .topInsets)
            .padding(.horizontal, 20)
            
            
        }
        .alert(isPresented: $mainVM.showError, content: {
            Alert(title: Text(Globs.AppName), message: Text(mainVM.errorMessage), dismissButton: .default(Text("OK")))
        })
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        
        
    }
}

#Preview {
    SignUpView(path: .constant(NavigationPath()))
}
