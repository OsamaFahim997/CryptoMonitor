//
//  StatisticView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 16/2/25.
//

import SwiftUI

struct StatisticView: View {
    
    var stat: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5, content: {
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
            
            Text(stat.value)
                .font(.headline)
                .foregroundColor(.theme.accent)
            
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (stat.percentageChange ?? 0) >= 0 ? 0 : 180 ))
                Text(stat.percentageChange?.convertPercentageToTwoDecimals() ?? "")
                    .font(.caption)
            }
            .foregroundColor((stat.percentageChange ?? 0) >= 0 ? .green : .red )
            .opacity(stat.percentageChange == nil ? 0.0 : 1.0)
            
            
        })
    }
}

#Preview {
    Group {
        StatisticView(stat: DeveloperPreview.instance.stat1)
            .preferredColorScheme(.dark)
            .padding(.vertical)
        
        StatisticView(stat: DeveloperPreview.instance.stat2)
            .preferredColorScheme(.light)
            .padding(.vertical)
        
        StatisticView(stat: DeveloperPreview.instance.stat3)
            .preferredColorScheme(.light)
            .padding(.vertical)
    }
    
}
