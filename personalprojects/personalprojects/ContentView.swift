//
//  ContentView.swift
//  personalprojects
//
//  Created by Nguyen on 9/4/26.
//

import SwiftUI

// MARK: ContentView

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)

                WalletView()
                    .tag(1)

                QRScanView()
                    .tag(2)

                PromotionView()
                    .tag(3)

                ProfileView()
                    .tag(4)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            MoMoTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar

struct MoMoTabBar: View {
    @Binding var selectedTab: Int

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill",        "Trang chủ"),
        ("wallet.pass.fill",  "Ví"),
        ("qrcode",            "Quét"),
        ("gift.fill",         "Khuyến mãi"),
        ("person.fill",       "Tài khoản"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color.white)
                .shadow(color: .black.opacity(0.10), radius: 16, x: 0, y: -4)
                .frame(height: 84)

            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { idx in
                    if idx == 2 {
                        qrButton(idx: idx)
                    } else {
                        tabButton(idx: idx)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 20)
        }
        .frame(height: 84)
    }

    @ViewBuilder
    private func qrButton(idx: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { selectedTab = idx }
        } label: {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.momoRed, Color.momoPink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 58, height: 58)
                    .shadow(color: Color.momoRed.opacity(0.45), radius: 10, x: 0, y: 5)
                Image(systemName: tabs[idx].icon)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .accessibilityLabel("Quét mã QR")
        .offset(y: -20)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private func tabButton(idx: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3)) { selectedTab = idx }
        } label: {
            VStack(spacing: 5) {
                Image(systemName: tabs[idx].icon)
                    .font(.system(size: 20))
                    .foregroundColor(selectedTab == idx ? .momoRed : .momoGray)
                    .scaleEffect(selectedTab == idx ? 1.12 : 1.0)
                    .animation(.spring(response: 0.25), value: selectedTab)

                Text(tabs[idx].label)
                    .font(.system(size: 10, weight: selectedTab == idx ? .semibold : .regular))
                    .foregroundColor(selectedTab == idx ? .momoRed : .momoGray)
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityLabel(tabs[idx].label)
        .accessibilityAddTraits(selectedTab == idx ? .isSelected : [])
    }
}

// MARK: - QR Scan View

struct QRScanView: View {
    @State private var isTorchOn = false
    @State private var showManualInput = false
    @State private var manualCode = ""

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ZStack {
                Color.black.opacity(0.85)

                // Scan frame
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.momoRed, lineWidth: 3)
                    .frame(width: 260, height: 260)
                    .overlay(scanCorners)

                // Corner scan animation
                ScanLineView()
                    .frame(width: 254, height: 254)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .ignoresSafeArea()

            // UI Overlay
            VStack {
                // Header
                ZStack {
                    LinearGradient(
                        colors: [Color.black.opacity(0.7), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)

                    HStack {
                        Spacer()
                        Text("Quét mã QR")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.top, 60)
                }

                Spacer()

                Text("Đưa mã QR vào khung để quét")
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.bottom, 160)
                
                Spacer()

                // Controls
                HStack(spacing: 50) {
                    controlButton(icon: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill",
                                  label: "Đèn pin") {
                        isTorchOn.toggle()
                    }
                    controlButton(icon: "photo.fill", label: "Thư viện") {}
                    controlButton(icon: "keyboard", label: "Nhập mã") {
                        showManualInput = true
                    }
                }
                .padding(.bottom, 10)

                Spacer(minLength: 100)
            }
        }
        .sheet(isPresented: $showManualInput) {
            ManualCodeInputView(code: $manualCode)
                .presentationDetents([.medium])
        }
    }

    private var scanCorners: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let len: CGFloat = 28
            let thick: CGFloat = 4
            let r: CGFloat = 20

            ZStack {
                // Top-left
                Path { p in
                    p.move(to: CGPoint(x: 0, y: r))
                    p.addArc(center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                    p.addLine(to: CGPoint(x: r + len, y: 0))
                }.stroke(Color.white, lineWidth: thick)
                Path { p in
                    p.move(to: CGPoint(x: 0, y: r))
                    p.addLine(to: CGPoint(x: 0, y: r + len))
                }.stroke(Color.white, lineWidth: thick)

                // Top-right
                Path { p in
                    p.move(to: CGPoint(x: w - r - len, y: 0))
                    p.addLine(to: CGPoint(x: w - r, y: 0))
                    p.addArc(center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
                    p.addLine(to: CGPoint(x: w, y: r + len))
                }.stroke(Color.white, lineWidth: thick)

                // Bottom-left
                Path { p in
                    p.move(to: CGPoint(x: 0, y: h - r - len))
                    p.addLine(to: CGPoint(x: 0, y: h - r))
                    p.addArc(center: CGPoint(x: r, y: h - r), radius: r, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
                    p.addLine(to: CGPoint(x: r + len, y: h))
                }.stroke(Color.white, lineWidth: thick)

                // Bottom-right
                Path { p in
                    p.move(to: CGPoint(x: w - r - len, y: h))
                    p.addLine(to: CGPoint(x: w - r, y: h))
                    p.addArc(center: CGPoint(x: w - r, y: h - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
                    p.addLine(to: CGPoint(x: w, y: h - r - len))
                }.stroke(Color.white, lineWidth: thick)
            }
        }
    }

    private func controlButton(icon: String, label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 56, height: 56)
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.8))
            }
        }
        .accessibilityLabel(label)
    }
}

// MARK: - Scan Line Animation

struct ScanLineView: View {
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.clear, Color.momoRed.opacity(0.8), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .offset(y: offset)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1.8)
                        .repeatForever(autoreverses: true)
                    ) {
                        offset = geo.size.height - 2
                    }
                }
        }
    }
}

// MARK: - Manual Code Input

struct ManualCodeInputView: View {
    @Binding var code: String
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            Text("Nhập mã thủ công")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.momoDark)
                .padding(.top, 24)

            TextField("Nhập mã thanh toán...", text: $code)
                .padding(14)
                .background(Color.momoLightGray)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 20)

            Button {
                dismiss()
            } label: {
                Text("Xác nhận")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.momoRed)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal, 20)
            }
            .disabled(code.isEmpty)
            .opacity(code.isEmpty ? 0.5 : 1)
            .accessibilityLabel("Xác nhận mã")

            Spacer()
        }
    }
}

// MARK: - Promotion View

struct PromotionView: View {
    let promos = MoMoData.promotions

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [.momoRed, .momoPink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea(edges: .top)

                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 120)
                        .offset(x: 130, y: -30)

                    VStack(spacing: 4) {
                        Text("KHUYẾN MÃI")
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Text("Ưu đãi dành riêng cho bạn")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom, 20)
                }
                .frame(height: 130)

                VStack(spacing: 12) {
                    ForEach(promos) { promo in
                        PromoCard(promo: promo)
                    }
                }
                .padding(16)
                .offset(y: -10)

                Spacer(minLength: 100)
            }
        }
        .background(Color.momoLightGray.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
    }
}

// MARK: - Promo Card

struct PromoCard: View {
    let promo: PromoItem

    var body: some View {
        Button { } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(promo.color.opacity(0.14))
                        .frame(width: 56, height: 56)
                    Image(systemName: promo.icon)
                        .font(.system(size: 22))
                        .foregroundColor(promo.color)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(promo.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.momoDark)
                    Text(promo.subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.momoGray)
                        .lineLimit(2)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.momoGray.opacity(0.5))
                    .font(.system(size: 13))
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        }
        .accessibilityLabel("\(promo.title). \(promo.subtitle)")
    }
}

#Preview {
    ContentView()
        .environmentObject(HomeViewModel())
        .environmentObject(WalletViewModel())
        .environmentObject(ProfileViewModel())
}
