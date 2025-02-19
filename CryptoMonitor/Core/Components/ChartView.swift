//
//  ChartView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 18/2/25.
//

import SwiftUI

struct ChartView: View {
    
    let data: [Double]
    let maxY: Double
    let minY: Double
    let lineColor: Color
    let startDate: Date
    let endDate: Date
    @State var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        self.data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        let change = (data.last ?? 0) - (data.first ?? 0)
        lineColor = change > 0 ? .theme.green : .theme.red
        endDate = Date(coinGeckoString: coin.lastUpdated ?? "")
        startDate = endDate.addingTimeInterval(-(7*24*60*60))
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .foregroundColor(lineColor)
                .background(chartBg)
                .overlay(alignment: .leading) { chartYAxis.padding(.horizontal, 5) }
            
            chartDateLabel
                .padding(.horizontal, 5)
        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                withAnimation(.linear(duration: 2.0)) {
                    percentage = 1
                }
            })
        })
            
    }
}

#Preview {
    ChartView(coin: DeveloperPreview.instance.coin)
}

extension ChartView {
    private var chartBg: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartView: some View {
        GeometryReader { geometry in
            Path { path in
                for index in data.indices {
                    
                    let xPosition = (geometry.size.width / CGFloat(data.count)) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY
                    // Because of iphone cordinate system, we have to do inverse
                    let beforeYPosition = 1 - CGFloat((data[index] - minY) / yAxis)
                    let yPosition = beforeYPosition * geometry.size.height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                }
            }
            .trim(from: 0.0, to: percentage)
            .stroke(lineWidth: 3.0)
            .shadow(color: lineColor, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 40)
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text("\( ((maxY - minY) / 2).formattedWithAbbreviations() )")
            Spacer()
            Text(maxY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabel: some View {
        HStack {
            Text(startDate.asShortDateString())
            Spacer()
            Text(endDate.asShortDateString())
        }
    }
}
