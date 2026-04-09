//
//  personalprojectsApp.swift
//  personalprojects
//
//  Created by Nguyen on 9/4/26.
//

import SwiftUI
 
@main
struct MoMoApp: App {
    @StateObject private var homeVM   = HomeViewModel()
    @StateObject private var walletVM = WalletViewModel()
    @StateObject private var profileVM = ProfileViewModel()
 
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(homeVM)
                .environmentObject(walletVM)
                .environmentObject(profileVM)
        }
    }
}
