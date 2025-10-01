struct PromoCodeCell: View {
    let pObj: PromoCodeModel
    let isPicker: Bool
    let didSelect: ((PromoCodeModel) -> Void)?
    @EnvironmentObject var navigationState: NavigationManager
    
    var body: some View {
        VStack {
            HStack {
                Text(pObj.title)
                    .font(.customfont(.bold, fontSize: 14))
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(pObj.code)
                    .font(.customfont(.bold, fontSize: 15))
                    .foregroundColor(.primaryApp)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.secondaryText.opacity(0.3))
                    .cornerRadius(5)
            }

            Text(pObj.description)
                .font(.customfont(.medium, fontSize: 14))
                .foregroundColor(.secondaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)

            HStack {
                Text("Expiry Date:")
                    .font(.customfont(.bold, fontSize: 14))
                    .foregroundColor(.primaryText)
                    .padding(.vertical, 8)

                Text(pObj.endDate.displayDate(format: "yyyy-MM-dd hh:mm a"))
                    .font(.customfont(.bold, fontSize: 12))
                    .foregroundColor(.secondaryText)
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(5)
        .shadow(color: Color.black.opacity(0.15), radius: 2)
        .onTapGesture {
            if isPicker {
                navigationState.removeLast()
                didSelect?(pObj)
            }
        }
    }
}
