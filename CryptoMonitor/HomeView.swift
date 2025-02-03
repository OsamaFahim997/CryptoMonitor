//
//  ContentView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 2/2/25.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
            
            VStack {
                homeHeader
                
                Spacer()
            }
        }
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
    .navigationBarHidden(true)
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(icon: showPortfolio ? "plus" : "info")
                .animation(.none)
                .background {
                    CircleButtonViewAnimation(animate: $showPortfolio)
                }
            
            Spacer()
            
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(.theme.accent)
                .animation(.none)
            
            Spacer()
            
            CircleButtonView(icon: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
}
