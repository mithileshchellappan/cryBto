//
//  ChartView.swift
//  cryBto
//
//  Created by Mithilesh Chellappan on 31/10/23.
//

import SwiftUI

struct ChartView: View {
    
    private let data: [Double]
    private let maxY: Double, minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    private let smallView: Bool
    @State private var percentage: CGFloat = 0
    
    
    
    
    init(coin: Coin, smallView: Bool = false){
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        self.smallView = smallView
        endingDate = Date(dateString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7 * 24 * 60 * 60)
        let priceChange = ((data.last ?? 0) - (data.first ?? 0))
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
    }
    
    
    var body: some View {
        VStack{
            chartView
                .frame(height:smallView ? 30 : 200)
                .background(smallView ? AnyView(EmptyView()) : AnyView(chartBackground))
                .overlay(smallView ? AnyView(EmptyView()) : AnyView(chartOverlay.padding(.horizontal,4)), alignment:.leading)
            if !smallView {
                chartLabels.padding(.horizontal,4)
            }
        }
        .foregroundColor(Color.theme.secondaryText)
        .onAppear{
            if self.smallView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.0){
                    withAnimation (.linear(duration: 1.0)) {
                        percentage = 1.0
                    }
                }
            }else{
                percentage = 1.0
            }
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView {
    
    
    private var chartLabels: some View {
        HStack{
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
        .font(.caption)
    }
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    let xPosition = ( geometry.size.width / CGFloat(data.count) ) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    
                    let yPosition = (1 - CGFloat(data[index] - minY) / yAxis ) * CGFloat(geometry.size.height)
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from:0,to:percentage)
            .stroke(lineColor,style:StrokeStyle(lineWidth: 2,lineCap: .round,lineJoin: .round))
            .shadow(color:lineColor.opacity(smallView ? 0.0 : 1.0), radius: 10,x: 0.0, y: 10.0)
            .shadow(color:lineColor.opacity(smallView ? 0.0 : 0.2), radius: 10,x: 0.0, y: 20.0)
        }
    }
    
    private var chartBackground: some View {
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartOverlay: some View {
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY ) / 2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
        .font(.caption)
    }
}



