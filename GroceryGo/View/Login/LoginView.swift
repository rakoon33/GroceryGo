//
//  LoginView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 18/6/25.
//

import SwiftUI

struct LoginView: View {
    
    @Binding var path: NavigationPath
//    @Environment(\.presentationMode) var mode: Binding<PresentationMode> nếu xài navigationView
    @StateObject var loginVM = MainViewModel.shared
    
    var body: some View {
        ZStack {
            Image("bottom_bg")
                .resizable()
                .scaledToFit()
                .frame(width: .screenWidth, height: .screenHeight)
            
            
            VStack {
                
                Image("color_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40)
                    .padding(.bottom, .screenWidth * 0.1)
                
                Text("login_title".localized)
                    .font(.customfont(.semibold, fontSize: 26))
                    .foregroundColor(.primaryText)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)
                
                Text("login_subtitle".localized)
                    .font(.customfont(.semibold, fontSize: 16))
                    .foregroundColor(.secondaryText)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, .screenWidth * 0.1)
                
                LineTextField(title: "login_email_title".localized,
                              placeholder: "login_email_placeholder".localized,
                              txt: $loginVM.txtEmail,
                              keyboardType: .emailAddress)
                .padding(.bottom, .screenWidth * 0.07)
                
                LineSecureField(title: "login_password_title".localized,
                                placeholder: "login_password_placeholder".localized,
                                txt: $loginVM.txtPassword,
                                isShowPassword: $loginVM.isShowPassword)
                .padding(.bottom, .screenWidth * 0.02)
                
                Button {
                    
                } label: {
                    Text("login_forgot_password".localized)
                        .font(.customfont(.medium, fontSize: 14))
                        .foregroundColor(.primaryText)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, .screenWidth * 0.05)
                
                RoundButton(title: "login_button".localized) {
                    Task {
                        await loginVM.login()
                    }
                }
                .padding(.bottom, .screenWidth * 0.05)

                
                
                HStack {
                    Text("login_no_account".localized)
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.primaryText)
                    
                    Text("signup_button".localized)
                        .font(.customfont(.semibold, fontSize: 14))
                        .foregroundColor(.primaryApp)
                }
                .onTapGesture {
                    path.append(AppRoute.signup) // Điều hướng sang SignUpView
                }
                
                Spacer()
                
            }
            .padding(.top, .topInsets + 64)
            .padding(.horizontal, 20)
            .padding(.bottom, .bottomInsets)
            
            VStack {
                HStack {
                    Button {
                        if !path.isEmpty {
                            path.removeLast() // bỏ màn hình hiện tại khỏi stack
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
            
            SpinnerView(isLoading: $loginVM.isLoading)
        }
        .alert(isPresented: $loginVM.showError) {
            
            Alert(title: Text(Globs.AppName), message: Text(loginVM.errorMessage), dismissButton: .default(Text("ok_button".localized)))
        }
        .background(.systemBackground)
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
        
    }
}

#Preview {
    LoginView(path: .constant(NavigationPath()))
}
