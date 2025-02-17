//
//  PortfolioView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 16/2/25.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State var selectedCoin: CoinModel? = nil
    @State var quantityText: String = ""
    @State var showCheckMark: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                SearchBarView(searchText: $vm.searchText)
                showCoinListView
                
                if selectedCoin != nil {
                    portfolioInputSection
                }
                
            }
            .navigationTitle("Edit Portfolio")
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    trailingNavBarButton
                }
            })
            .onChange(of: vm.searchText, { _, newValue in
                if newValue.isEmpty {
                    self.removeSelectedCoin()
                }
            })
        }
    }
    
    func getCurrentValue() -> String {
        if let amount = Double(quantityText), let coin = selectedCoin {
            return (amount * coin.currentPrice).asCurrencyWith2Decimals()
        }
        return "0.0"
    }
}

#Preview {
    PortfolioView()
        .environmentObject(HomeViewModel())
}

extension PortfolioView {
    
    private var showCoinListView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding()
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedCoin = coin
                                quantityText = vm.checkForCurrentHolding(of: selectedCoin)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ? Color.theme.green : Color.clear,
                                        lineWidth: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading)
        }
    }
    
    private var portfolioInputSection: some View {
        VStack(spacing: 10, content: {
            HStack(content: {
                Text("Current Price of \(selectedCoin?.symbol.uppercased() ?? ""): ")
                Spacer()
                Text("$ \(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")")
            })
            
            Divider()
            HStack(content: {
                Text("Your Portfolio amount")
                Spacer()
                TextField("Ex. 1.4", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            })
            
            Divider()
            HStack(content: {
                Text("Current Value: ")
                Spacer()
                Text(getCurrentValue())
            })
        })
        .padding()
        .font(.headline)
    }
    
    private var trailingNavBarButton: some View {
        HStack {
            Image(systemName: "checkmark")
                .opacity(showCheckMark ? 1.0 : 0.0)
            
            Button(action: {
                saveButtonPressed()
            }, label: {
                Text("SAVE")
            })
            .opacity(
                selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText) ? 1.0 : 0.0
            )
        }
    }
    
    private func saveButtonPressed() {
        guard let coin = selectedCoin, let amount = Double(quantityText) else { return }
        
        // save to portfolio
        vm.updatePortfolio(coin: coin, amount: amount)
        
        // showing animation and removing selected coin
        withAnimation(.easeInOut) {
            showCheckMark = true
            removeSelectedCoin()
        }
        
        // dismiss keyboard
        UIApplication.shared.endEditing()
        
        // removing checkmark after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            withAnimation(.easeInOut) {
                showCheckMark = false
            }
        })
    }
    
    private func removeSelectedCoin() {
        selectedCoin = nil
        vm.searchText = ""
    }
    
}
