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

// MARK: - CosmicTabBar

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
    
    // MARK: QR centre button
    
    private var qrButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { selectedTab = 2 }
        } label: {
            ZStack {
                
                Circle()
                    .fill(Color.appPrimary.opacity(qrPulse ? 0.18 : 0.04))
                    .frame(width: 72)
                
                
                Circle()
                    .stroke(
                        AngularGradient(colors: [.appPrimary, .cosmicCyan, .cosmicPink, .appPrimary],
                                        center: .center),
                        lineWidth: 2.5
                    )
                    .frame(width: 64)
                    .rotationEffect(.degrees(ringAngle))
                    .opacity(selectedTab == 2 ? 1 : 0.5)
                
                
                Circle()
                    .fill(CG.button)
                    .frame(width: 56)
                    .overlay(
                        Circle().fill(
                            RadialGradient(colors: [.white.opacity(0.25), .clear],
                                           center: .init(x: 0.35, y: 0.25),
                                           startRadius: 0, endRadius: 28)
                        )
                    )
                    .appButtonShadow(color: .appPrimary)
                
                Image(systemName: "qrcode.viewfinder")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(selectedTab == 2 ? 1.12 : 1.0)
                    .animation(.spring(response: 0.3), value: selectedTab)
            }
        }
        .buttonStyle(CosmicButtonStyle())
        .accessibilityLabel("Quét mã QR")
        .offset(y: -20)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: Regular tab button
    private func tabButton(_ i: Int) -> some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { selectedTab = i }
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if selectedTab == i {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.appPrimary.opacity(0.18))
                            .frame(width: 38, height: 32)
                            .cosmicGlow(color: .appPrimary, radius: 6)
                    }
                    Image(systemName: tabs[i].icon)
                        .font(.system(size: 20, weight: selectedTab == i ? .semibold : .regular))
                        .foregroundColor(selectedTab == i ? .appSecondary : Color(white: 0.42))
                        .scaleEffect(selectedTab == i ? 1.1 : 1.0)
                        .animation(.spring(response: 0.25, dampingFraction: 0.65), value: selectedTab)
                }
                Text(tabs[i].label)
                    .font(.system(size: 9, weight: selectedTab == i ? .bold : .medium))
                    .foregroundColor(selectedTab == i ? .appSecondary : Color(white: 0.38))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(CosmicButtonStyle())
        .accessibilityLabel(tabs[i].label)
        .accessibilityAddTraits(selectedTab == i ? .isSelected : [])
    }
    
    // MARK: - QRScanView
    
    struct QRScanView: View {
        @State private var isTorchOn      = false
        @State private var showInput      = false
        @State private var manualCode     = ""
        @State private var scanRotation   = 0.0
        @State private var cornerPulse    = false
        
        var body: some View {
            ZStack {
                Color.spaceBlack.ignoresSafeArea()
                StarfieldView(starCount: 50)
                
                Color.black.opacity(0.78).ignoresSafeArea()
                
                // Scan frame
                ZStack {
                    // Outer glow
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.appPrimary.opacity(cornerPulse ? 0.55 : 0.15), lineWidth: 2)
                        .frame(width: 270, height: 270)
                        .blur(radius: 4)
                    
                    // Rotating border
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(AngularGradient(colors: [.appPrimary, .cosmicCyan, .cosmicPink, .appPrimary],
                                                center: .center), lineWidth: 2.5)
                        .frame(width: 262, height: 262)
                        .rotationEffect(.degrees(scanRotation))
                    
                    // Corners
                    scanCorners.frame(width: 262, height: 262)
                    
                    // Scan line
                    CosmicScanLine().frame(width: 256, height: 256)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                
                VStack {
                    // Header
                    LinearGradient(colors: [Color.spaceBlack, .clear], startPoint: .top, endPoint: .bottom)
                        .frame(height: 140)
                        .overlay(
                            VStack(spacing: 4) {
                                Text("Quét mã QR")
                                    .font(.system(size: 20, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("Vũ trụ rộng lớn, thanh toán nhanh chóng")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(white: 0.55))
                            }
                                .padding(.top, 60)
                        )
                    
                    Spacer()
                    
                    Text("Đưa mã QR vào khung để quét")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.bottom, 250)
                    
                    Spacer()
                    
                    HStack(spacing: 38) {
                        scanCtrlBtn(icon: isTorchOn ? "flashlight.on.fill" : "flashlight.off.fill",
                                    label: "Đèn pin", color: isTorchOn ? .cosmicGold : .appSecondary) {
                            isTorchOn.toggle()
                        }
                        scanCtrlBtn(icon: "photo.fill",  label: "Thư viện", color: .cosmicCyan) {}
                        scanCtrlBtn(icon: "keyboard",     label: "Nhập mã",  color: .appPrimary) { showInput = true }
                    }
                    Spacer(minLength: 110)
                }
            }
            .sheet(isPresented: $showInput) {
                ManualCodeSheet(code: $manualCode).presentationDetents([.medium])
            }
            .onAppear {
                withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) { scanRotation = 360 }
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) { cornerPulse = true }
            }
        }
        
    }
}
#Preview {
    ContentView()
        .environmentObject(HomeViewModel())
        .environmentObject(WalletViewModel())
        .environmentObject(ProfileViewModel())
}

