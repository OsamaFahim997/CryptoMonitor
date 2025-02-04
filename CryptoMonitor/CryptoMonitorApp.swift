//
//  CryptoMonitorApp.swift
//  CryptoMonitor
//
//  Created by Osama Fahim on 2/2/25.
//

import SwiftUI

@main
struct CryptoMonitorApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
            }
            .navigationBarHidden(true)
            .environmentObject(homeViewModel)
        }
    }
}
