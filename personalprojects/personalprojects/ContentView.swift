import SwiftUI


struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        ZStack(alignment: .bottom) {
            NebulaBackground()

            TabView(selection: $selectedTab) {
                HomeView(onNavigateToTab: { tab in
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.72)) { selectedTab = tab }
                })
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

            CosmicTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(.dark)
    }
}

struct CosmicTabBar: View {
    @Binding var selectedTab: Int
    @State private var ringAngle: Double = 0
    @State private var qrPulse  = false

    private let tabs: [(icon: String, label: String)] = [
        ("house.fill",      "Trang chủ"),
        ("paperplane.fill", "Chuyển tiền"),
        ("qrcode",          "Quét"),
        ("sparkles",        "Ưu đãi"),
        ("person.fill",     "Tôi"),
    ]

    var body: some View {
        ZStack(alignment: .bottom) {
            // Glass bar
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.spaceDark.opacity(0.95))
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(CG.cardBorder, lineWidth: 1)
                )
                .frame(height: 80)
                .padding(.horizontal, 16)
                .shadow(color: Color.appPrimary.opacity(0.25), radius: 20, x: 0, y: -4)
                .shadow(color: .black.opacity(0.50), radius: 10, x: 0, y: 4)

            HStack(spacing: 0) {
                ForEach(0..<5) { i in
                    if i == 2 { qrButton } else { tabButton(i) }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 18)
            .frame(height: 80)
        }
        .frame(height: 80)
        .padding(.bottom, 20)
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) { ringAngle = 360 }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { qrPulse = true }
        }
    }
