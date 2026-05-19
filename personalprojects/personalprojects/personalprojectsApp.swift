// personalprojectsApp.swift
// personalprojects
//
// Created by Vu Cao Nguyen on 18/3/26

import SwiftUI

@main
struct CosmicWalletApp: App {
    @StateObject private var homeVM    = HomeViewModel()
    @StateObject private var walletVM  = WalletViewModel()
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
