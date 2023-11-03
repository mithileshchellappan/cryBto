//
//  CoinRowView.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 27/10/23.
//

import SwiftUI

struct CoinRowView: View {
    let coin: Coin
    let showHoldingsColumn: Bool
    var body: some View {
        
        HStack(spacing: 0){
            leftColumn
            Spacer()
            if showHoldingsColumn {
                centerColumn
            }else{
                
                ChartView(coin: coin, smallView: true)
                    .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                
            }
            
            rightColumn
            
        }
        .font(.subheadline)
        .background(
            Color.theme.background.opacity(0.001)
        )
    }
    
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing:0){
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin)
                .frame(width: 30,height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundColor(Color.theme.accent)
        }
    }
    
    private var centerColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWithNDecimals(max:1))
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberAsString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    private var rightColumn: some View {
        VStack(alignment: .trailing){
            Text(coin.currentPrice.asCurrencyWithNDecimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text((coin.priceChangePercentage24H ?? 0).asPercentString())
                .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
        }
        
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            CoinRowView(coin: dev.coin,showHoldingsColumn: false)
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin,showHoldingsColumn: true)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
