//
//  SettingsView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 25/2/25.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.com")!
    let youtubeURL = URL(string: "https://www.youtube.com")!
    let profileURL = URL(string: "https://www.osamafahim.com")!
    
    
    var body: some View {
        NavigationView {
            List {
                descriptionSection
                coinGeckoSection
                applicationSection
            }
        }
        .font(.headline)
        .accentColor(.blue)
        .listStyle(GroupedListStyle())
        .navigationTitle("Settings")
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                XMarkButton()
            }
        })
    }
}

#Preview {
    NavigationView {
        SettingsView()
    }
}

extension SettingsView {
    
    private var descriptionSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo", bundle: nil)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                
                Text("This is take home project for crypto tracking by following youtube course mentioned below")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            
            Link("Subscribe on Youtube", destination: defaultURL)
            Link("Support by buying a coffee for me", destination: profileURL)
        } header: {
            Text("Crypto Monitor")
        }
    }
    
    private var coinGeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko", bundle: nil)
                    .resizable()
                    .frame(height: 100)
                    .cornerRadius(10)
                
                Text("This is take home project for crypto tracking by following youtube course mentioned below")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(.theme.accent)
            }
            .padding(.vertical)
            
            Link("Subscribe on Youtube", destination: defaultURL)
            Link("Support by buying a coffee for me", destination: profileURL)
        } header: {
            Text("Coin Gecko")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms & Conditions", destination: defaultURL)
            Link("Privacy policy", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
    
}
