//
//  AccountView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 7/9/25.
//


import SwiftUI

struct AccountView: View {
    @Binding var path: NavigationPath
    @StateObject private var session = SessionManager.shared

    var body: some View {
        
        let user = session.user
        
        ZStack {
            VStack {
                HStack {
                    Image("u1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .cornerRadius(30)
                    VStack {
                        HStack {
               
                            Text("Hello, \(user?.username ?? "Rakoon")")
                                .font(.customfont(.bold, fontSize: 16))
                                .foregroundColor(.primaryText)
                        
                            Image(systemName: "pencil")
                                .foregroundColor(.primaryApp)
                            
                            Spacer()
                        }
                        .padding(.bottom, 2)
                        
                    Text( "\(user?.email ?? "Rakoon@gmail.com")")
                            .font(.customfont(.regular, fontSize: 16))
                            .foregroundColor(.secondaryText)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .accentColor(.secondaryText)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, .topInsets)
                
                Divider()
                
                ScrollView {
                    LazyVStack {
                        VStack {
                            AccountCell(item: .orders)
                            AccountCell(item: .myDetails)
                            AccountCell(item: .deliveryAddress)
                            AccountCell(item: .paymentMethods)
                            AccountCell(item: .promoCode)
                        }

                        VStack {
                            AccountCell(item: .notifications)
                            AccountCell(item: .help)
                            AccountCell(item: .about)
                        }
                        
                        Button {
                            session.logout()
                        } label: {
                            ZStack {
                                
                                Text("logout".localized)
                                    .font(.customfont(.semibold, fontSize: 18))
                                    .foregroundColor(.primaryApp)
                                    .multilineTextAlignment(.center)
                                
                                HStack {
                                    Spacer()
                                    
                                    Image("logout")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .padding(.trailing, 20)
                                }
               
                            }
                            
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 60, maxHeight: 60)
                        .background(Color(hex: "F3F3F2"))
                        .cornerRadius(20)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                    }
                }
            }
            .padding(.bottom, .bottomInsets + 60)
        }
        .navigationTitle("")
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea()
    }
}

#Preview {
    AccountView(path: .constant(NavigationPath()))
}



//VStack {
//    if let user = session.user {
//        Text("Hello, \(user.username)")
//            .font(.headline)
//            .padding(.bottom, 20)
//        
//        Button(action: {
//            session.logout()
//        }) {
//            Text("Logout")
//                .font(.customfont(.semibold, fontSize: 16))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .padding()
//                .background(Color.red)
//                .cornerRadius(10)
//                .padding(.horizontal, 20)
//        }
//    } else {
//        Text("Not logged in")
//            .foregroundColor(.secondary)
//    }
//}
//.frame(maxWidth: .infinity, maxHeight: .infinity)
//.background(Color(.systemGroupedBackground))
