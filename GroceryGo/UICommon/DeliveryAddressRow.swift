//
//  DeliveryAddressRow.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 11/9/25.
//

import SwiftUI


struct DeliveryAddressRow: View {
    let aObj: AddressModel
    let onRemove: ((Int) -> Void)?
    let onEdit: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 15) {
            VStack {
                HStack {
                    Text(aObj.name)
                        .font(.customfont(.bold, fontSize: 14))
                        .foregroundColor(.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(aObj.typeName)
                        .font(.customfont(.semibold, fontSize: 12))
                        .foregroundColor(.primaryText)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.secondaryText.opacity(0.3))
                        .cornerRadius(5)
                }
                
                Text("\(aObj.address), \(aObj.city), \(aObj.state), \(aObj.postalCode)")
                    .font(.customfont(.medium, fontSize: 14))
                    .foregroundColor(.primaryText)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(aObj.phone)
                    .font(.customfont(.bold, fontSize: 12))
                    .foregroundColor(.secondaryText)
                    .padding(.vertical, 8) // sửa lỗi .padding(.verticalm)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Spacer()
                
                Button {
                    onEdit?()
                } label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primaryApp)
                }
                .padding(.bottom, 8)
                
                Button {
                    onRemove?(aObj.id)
                } label: {
                    Image("close")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                }
                
                Spacer()
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 2)
    }
}

#Preview {
    DeliveryAddressRow(
        aObj: AddressModel(
            id: 1,
            name: "Nam",
            phone: "0123456789",
            address: "123 Main St",
            city: "Hanoi",
            state: "HN",
            typeName: "Home",
            postalCode: "100000",
            isDefault: 1
        ),
        onRemove: {_ in},
        onEdit: {}
    )
}
