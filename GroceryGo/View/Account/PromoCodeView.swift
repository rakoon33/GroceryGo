//
//  PromoCodeView.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI
struct PromoCodeView: View {
    
    @EnvironmentObject var navigationState: NavigationManager
    
    @StateObject var promoVM = PromoCodeViewModel.shared
    @State var isPicker: Bool = false
    var didSelect:( (_ obj: PromoCodeModel) -> () )?
    
    var body: some View {
        ZStack{
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(promoVM.listArr, id: \.id) { pObj in
                        PromoCodeCell(
                            pObj: pObj,
                            isPicker: isPicker,
                            didSelect: didSelect
                        )
                    }
                }
                .padding(20)
                .padding(.top, .topInsets + 46)
                .padding(.bottom, .bottomInsets + 60)
            }
            
            VStack {
                
                HStack{
                    
                    Button {
                        navigationState.removeLast()
                    } label: {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                    
                    Spacer()
                    
                    Text("Promo Code")
                        .font(.customfont(.bold, fontSize: 20))
                        .frame(height: 46)
                    Spacer()
                    
                    
                }
                .padding(.top, .topInsets)
                .padding(.horizontal, 20)
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.2),  radius: 2 )
                
                Spacer()
                
            }
            
            
            
        }
        .task {
            await promoVM.fetchPromoCodeList()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
    }
}
#Preview {
    PromoCodeView()
}
