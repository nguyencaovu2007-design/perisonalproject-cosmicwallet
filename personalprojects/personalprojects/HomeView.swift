//
//  HomeView.swift
//  personalprojects
//
//  Created by Nguyen on 7/5/26.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    var onNavigateToTab: ((Int) -> Void)? = nil
    
    @State private var appeared    = false
    @State private var balanceGlow = false
    @State private var orbitAngle  = 0.0
    
    var body: some View {
        ZStack(alignment: .top) {
            NebulaBackground()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    header.zIndex(1)
                    
                    balanceCard
                        .padding(.horizontal, AppSpacing.lg)
                        .offset(y: -28)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.10), value: appeared)
                    
                    servicesSection
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.18), value: appeared)
                    
                    promoBanner
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.lg)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.26), value: appeared)
                    
                    transactionsSection
                        .padding(.top, AppSpacing.lg)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.34), value: appeared)
                    
                    Spacer(minLength: 110)
                }
            }
            .refreshable { await vm.refresh() }
        }
        .onAppear {
            appeared = true
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { balanceGlow = true }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) { orbitAngle = 360 }
        }
        .onDisappear { appeared = false }
    }
    
    // MARK: Header
    
    private var header: some View {
        ZStack {
            CG.header.ignoresSafeArea(edges: .top)
            StarfieldView(starCount: 40).frame(height: 165).clipped()
            
            // Nebula orbs
            Circle()
                .fill(RadialGradient(colors: [Color.appPrimary.opacity(0.38), .clear],
                                     center: .center, startRadius: 0, endRadius: 80))
                .frame(width: 160).offset(x: 130, y: -20)
            Circle()
                .fill(RadialGradient(colors: [Color.cosmicBlue.opacity(0.22), .clear],
                                     center: .center, startRadius: 0, endRadius: 60))
                .frame(width: 120).offset(x: -130, y: 30)
            
            // Orbiting dot around avatar
            Circle().fill(Color.cosmicGold).frame(width: 5)
                .offset(x: -28 + cos(orbitAngle * .pi / 180) * 30,
                        y:  0  + sin(orbitAngle * .pi / 180) * 30)
                .blur(radius: 1)
            
            HStack(alignment: .center) {
                HStack(spacing: 12) {
                    // Avatar
                    ZStack {
                        Circle()
                            .stroke(AngularGradient(colors: [.appPrimary, .cosmicCyan, .cosmicPink, .appPrimary],
                                                    center: .center), lineWidth: 2)
                            .frame(width: 50, height: 50)
                        Circle().fill(Color.spaceElevated).frame(width: 44, height: 44)
                        Text(vm.initials)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundColor(.appSecondary)
                    }
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Xin chào")
                            .font(.system(size: 12, weight: .medium)).foregroundColor(Color(white: 0.55))
                        Text(vm.userName)
                            .font(.system(size: 17, weight: .bold)).foregroundColor(.white)
                    }
                }
                Spacer()
                HStack(spacing: 18) {
                    Button { withAnimation(.spring(response: 0.3)) { vm.hasNotification = false } } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill").font(.system(size: 20)).foregroundColor(Color(white: 0.80))
                            if vm.hasNotification {
                                Circle().fill(Color.cosmicGold).frame(width: 9, height: 9)
                                    .cosmicGlow(color: .cosmicGold, radius: 4).offset(x: 3, y: -2)
                            }
                        }
                    }
                    Button { } label: {
                        Image(systemName: "magnifyingglass").font(.system(size: 20)).foregroundColor(Color(white: 0.80))
                    }
                }
            }
            .padding(.horizontal, AppSpacing.xl)
        }
        .frame(height: 110)
        .padding(.bottom, 54)
    }
}
