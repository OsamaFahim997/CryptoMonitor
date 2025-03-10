//
//  ContentView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 2/2/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var showPortfolio = false // for animation
    @State private var showPortfolioView = false // new sheet
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
    var body: some View {
        ZStack {
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortfolioView, content: {
                    PortfolioView()
                        .environmentObject(homeViewModel)
                })
            
            VStack {
                homeHeader
                
                HomeStatView(showPortfolio: self.$showPortfolio)
                
                SearchBarView(searchText: $homeViewModel.searchText)
                
                columnTitles
                
                if showPortfolio {
                    portfolioCoinsList
                    .transition(.move(edge: .trailing))
                } else {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                
                Spacer()
            }
            .background(
                NavigationLink(
                    destination: DetailLoadingView(coin: $selectedCoin),
                    isActive: $showDetailView,
                    label: { EmptyView() })
            )
        }
    }
    
    var allCoinsList: some View {
        List {
            ForEach(homeViewModel.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
                    .onTapGesture {
                        segue(coin: coin)
                    }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    var portfolioCoinsList: some View {
        List {
            ForEach(homeViewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColumn: showPortfolio)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    func segue(coin: CoinModel) {
        selectedCoin = coin
        showDetailView = true
    }
}

#Preview {
    NavigationView {
        HomeView()
    }
    .navigationBarHidden(true)
    .environmentObject(HomeViewModel())
}

extension HomeView {
    private var homeHeader: some View {
        HStack {
            CircleButtonView(icon: showPortfolio ? "plus" : "info")
                .onTapGesture {
                    if showPortfolio {
                        showPortfolioView.toggle()
                    }
                }
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
    
    private var columnTitles: some View {
        HStack {
            HStack {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(homeViewModel.sort == .byRank || homeViewModel.sort == .byRankReversed ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees: homeViewModel.sort == .byRank ? 0 : 180))
            }
            .onTapGesture {
                withAnimation(.none) {
                    toggleSort(sort: .byRank)
                }
            }
            
            Spacer()
            if showPortfolio {
                HStack {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(homeViewModel.sort == .byHoldings || homeViewModel.sort == .byHoldingsReversed ? 1.0 : 0.0 )
                        .rotationEffect(Angle(degrees: homeViewModel.sort == .byHoldings ? 0 : 180))
                }
                .onTapGesture {
                    withAnimation(.none) {
                        toggleSort(sort: .byHoldings)
                    }
                }
            }
            HStack {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(homeViewModel.sort == .byPrice || homeViewModel.sort == .byPriceReversed ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees: homeViewModel.sort == .byPrice ? 0 : 180))
            }
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
                .onTapGesture {
                    withAnimation(.none) {
                        toggleSort(sort: .byPrice)
                    }
                }
            
            Button {
                withAnimation(.linear(duration: 2.0)) {
                    homeViewModel.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
            }
            .rotationEffect(Angle(degrees: homeViewModel.isLoading ? 360 : 0), anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

        }
        .font(.caption)
        .foregroundColor(.theme.secondaryText)
        .padding(.horizontal)
    }
    
    private func toggleSort(sort: HomeViewModel.SortingOption) {
        switch sort {
        case .byHoldings, .byHoldingsReversed:
            homeViewModel.sort = homeViewModel.sort == .byHoldings ? .byHoldingsReversed : .byHoldings
        case .byPrice, .byPriceReversed:
            homeViewModel.sort = homeViewModel.sort == .byPrice ? .byPriceReversed : .byPrice
        case .byRank, .byRankReversed:
            homeViewModel.sort = homeViewModel.sort == .byRank ? .byRankReversed : .byRank
        }
    }
}
