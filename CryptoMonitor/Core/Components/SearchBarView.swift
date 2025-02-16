//
//  SearchBarView.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 16/2/25.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.theme.secondaryText)
            
            TextField("Search by any name or symbol", text: $searchText)
                .foregroundColor(.theme.accent)
                .overlay(alignment: .trailing, content: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.theme.accent)
                        .padding()
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                            UIApplication.shared.endEditing()
                        }
                })
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: .theme.accent.opacity(0.15), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        )
        .padding()
    }
}

#Preview {
    SearchBarView(searchText: .constant(""))
}
