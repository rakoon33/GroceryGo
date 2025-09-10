//
//  AccountCell.swift
//  GroceryGo
//
//  Created by Phạm Văn Nam on 10/9/25.
//

import SwiftUI

struct AccountCell: View {
    let item: AccountItem

    var body: some View {
        HStack(spacing: 15) {
            Image(item.icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            Text(item.title)
                .font(.customfont(.semibold, fontSize: 16))
                .foregroundColor(.primaryText)
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

            Image("next")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .foregroundColor(.primaryText)
        }
        .padding(20)

        Divider()
    }
}

#Preview {
    AccountCell(item: .orders)
}
