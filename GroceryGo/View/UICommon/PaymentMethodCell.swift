//
//  PaymentMethodCell.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 30/9/25.
//

import SwiftUI

struct PaymentMethodCell: View {
    let pObj: PaymentModel
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            Image("a_payment_methods")
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            
            VStack(spacing: 4) {
                Text(pObj.name)
                    .font(.customfont(.bold, fontSize: 18))
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("**** **** **** \(pObj.cardNumber)")
                    .font(.customfont(.medium, fontSize: 15))
                    .foregroundColor(.primaryApp)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Button(action: onRemove) {
                Image("close")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 2)
    }
}

#Preview {
    PaymentMethodCell(pObj: PaymentModel(), onRemove: {} )
        .padding(.horizontal, 20)
}
