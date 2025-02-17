//
//  XMarkButton.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 16/2/25.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var isPresented
    
    var body: some View {
        Button(action: {
            isPresented.callAsFunction()
        }, label: {
            Image(systemName: "xmark")
        })
    }
}

#Preview {
    XMarkButton()
}
