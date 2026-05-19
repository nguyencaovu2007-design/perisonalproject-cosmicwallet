import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel
    var onNavigateToTab: ((Int) -> Void)? = nil

    @State private var appeared    = false
    @State private var balanceGlow = false
    @State private var orbitAngle  = 0.0

    var body: some View {
        GeometryReader { geo in
            let topInset = geo.safeAreaInsets.top
            ZStack(alignment: .top) {
                NebulaBackground()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        header(topInset: topInset)

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
                .ignoresSafeArea(edges: .top)
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            appeared = true
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) { balanceGlow = true }
            withAnimation(.linear(duration: 12).repeatForever(autoreverses: false)) { orbitAngle = 360 }
        }
        .onDisappear { appeared = false }
    }

    // MARK: Header — phủ full từ viền máy xuống (kể cả Dynamic Island / Notch)

    private func header(topInset: CGFloat) -> some View {
        let totalHeight = topInset + 110

        return ZStack(alignment: .top) {
            // Background phủ full lên trên
            CG.header
                .frame(height: totalHeight)

            StarfieldView(starCount: 40)
                .frame(height: totalHeight)
                .clipped()

            // Nebula orbs
            Circle()
                .fill(RadialGradient(colors: [Color.appPrimary.opacity(0.38), .clear],
                                     center: .center, startRadius: 0, endRadius: 80))
                .frame(width: 160)
                .offset(x: 130, y: topInset - 20)

            Circle()
                .fill(RadialGradient(colors: [Color.cosmicBlue.opacity(0.22), .clear],
                                     center: .center, startRadius: 0, endRadius: 60))
                .frame(width: 120)
                .offset(x: -130, y: topInset + 10)

            // Orbiting dot
            Circle().fill(Color.cosmicGold).frame(width: 5)
                .offset(
                    x: -28 + cos(orbitAngle * .pi / 180) * 30,
                    y: topInset + sin(orbitAngle * .pi / 180) * 30
                )
                .blur(radius: 1)

            // Avatar + tên + icons — bắt đầu ngay dưới Dynamic Island
            HStack(alignment: .center) {
                HStack(spacing: 12) {
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
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(white: 0.55))
                        Text(vm.userName)
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                Spacer()
                HStack(spacing: 18) {
                    Button {
                        withAnimation(.spring(response: 0.3)) { vm.hasNotification = false }
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(white: 0.80))
                            if vm.hasNotification {
                                Circle().fill(Color.cosmicGold).frame(width: 9, height: 9)
                                    .cosmicGlow(color: .cosmicGold, radius: 4)
                                    .offset(x: 3, y: -2)
                            }
                        }
                    }
                    Button { } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(Color(white: 0.80))
                    }
                }
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, topInset + 14)   // đẩy xuống dưới Dynamic Island
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(height: totalHeight)
        .padding(.bottom, 54)
    }

    // MARK: Balance Card

    private var balanceCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack(spacing: 6) {
                        Image(systemName: "moon.stars.fill").font(.system(size: 12)).foregroundColor(.appSecondary)
                        Text("Số dư ví").font(.system(size: 13, weight: .semibold)).foregroundColor(Color(white: 0.55))
                        Button { vm.toggleBalance() } label: {
                            Image(systemName: vm.isBalanceHidden ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 13)).foregroundColor(Color(white: 0.45))
                        }
                    }
                    Text(vm.displayBalance)
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundColor(vm.isBalanceHidden ? Color(white: 0.45) : .white)
                        .shadow(color: Color.appPrimary.opacity(balanceGlow ? 0.50 : 0.0), radius: 10)
                        .animation(.easeInOut(duration: 3).repeatForever(autoreverses: true), value: balanceGlow)
                        .animation(.spring(response: 0.3), value: vm.isBalanceHidden)
                }
                Spacer()
                Button { onNavigateToTab?(2) } label: {
                    VStack(spacing: 6) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.appPrimary.opacity(0.18))
                                .frame(width: 58, height: 58)
                                .overlay(RoundedRectangle(cornerRadius: 16)
                                    .stroke(LinearGradient(colors: [.appPrimary, .cosmicCyan],
                                                           startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1))
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 25, weight: .semibold)).foregroundColor(.appSecondary)
                        }.cosmicGlow(color: .appPrimary, radius: 8)
                        Text("Mã QR").font(.system(size: 11, weight: .bold)).foregroundColor(.appSecondary)
                    }
                }.buttonStyle(CosmicButtonStyle())
            }
            .padding(.horizontal, AppSpacing.xl)
            .padding(.top, AppSpacing.xl)

            LinearGradient(colors: [.clear, Color.appPrimary.opacity(0.4), .clear],
                           startPoint: .leading, endPoint: .trailing)
                .frame(height: 1).padding(.horizontal, AppSpacing.xl).padding(.vertical, AppSpacing.md)

            HStack(spacing: 0) {
                quickBtn(icon: "paperplane.fill",            title: "Chuyển",    color: .appPrimary) { onNavigateToTab?(1) }
                quickBtn(icon: "arrow.down.left.circle.fill", title: "Nhận",     color: .appGreen)   { }
                quickBtn(icon: "plus.circle.fill",            title: "Nạp ví",   color: .cosmicCyan) { }
                quickBtn(icon: "wand.and.stars",              title: "Rút tiền", color: .appOrange)  { }
            }
            .padding(.bottom, AppSpacing.lg)
        }
        .background(Color.spaceCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
        .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(CG.cardBorder, lineWidth: 1))
        .appElevatedShadow()
    }

    private func quickBtn(icon: String, title: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 9) {
                ZStack {
                    Circle().fill(color.opacity(0.15)).frame(width: 52, height: 52)
                        .overlay(Circle().stroke(color.opacity(0.25), lineWidth: 1))
                    Image(systemName: icon).font(.system(size: 19, weight: .semibold)).foregroundColor(color)
                }.cosmicGlow(color: color, radius: 6)
                Text(title).font(.system(size: 11, weight: .bold)).foregroundColor(Color(white: 0.72))
            }.frame(maxWidth: .infinity)
        }.buttonStyle(CosmicButtonStyle())
    }

    // MARK: Services

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "sparkle").font(.system(size: 14, weight: .semibold)).foregroundColor(.cosmicGold)
                    Text("Dịch vụ").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.white)
                }.padding(.leading, AppSpacing.xl)
                Spacer()
                Button("Xem thêm") { }
                    .font(.system(size: 14, weight: .semibold)).foregroundColor(.appSecondary).padding(.trailing, AppSpacing.xl)
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4), spacing: 18) {
                ForEach(Array(vm.services.enumerated()), id: \.element.id) { i, s in
                    CosmicServiceCell(service: s)
                        .opacity(appeared ? 1 : 0).offset(y: appeared ? 0 : 15)
                        .animation(.spring(response: 0.45, dampingFraction: 0.75).delay(0.26 + Double(i) * 0.055), value: appeared)
                }
            }.padding(.horizontal, AppSpacing.lg)
        }
        .padding(.vertical, AppSpacing.lg)
        .background(Color.spaceDark)
    }

    // MARK: Promo Banner

    private var promoBanner: some View {
        ZStack(alignment: .leading) {
            CG.promo.clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            StarfieldView(starCount: 15).clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            Circle()
                .fill(RadialGradient(colors: [Color.cosmicCyan.opacity(0.25), .clear],
                                      center: .center, startRadius: 0, endRadius: 60))
                .frame(width: 120).offset(x: 240)
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.white.opacity(0.20)).frame(width: 48)
                    Image(systemName: "sparkles").font(.system(size: 22, weight: .bold)).foregroundColor(.cosmicGold)
                }.cosmicGlow(color: .cosmicGold, radius: 10)
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hoàn tiền 20% 🪐").font(.system(size: 15, weight: .black)).foregroundColor(.white)
                    Text("Thanh toán tại cửa hàng vũ trụ").font(.system(size: 12)).foregroundColor(.white.opacity(0.80))
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 13, weight: .bold)).foregroundColor(.white.opacity(0.7))
            }.padding(AppSpacing.md + 2)
        }
        .frame(height: 78).appCardShadow()
    }

    // MARK: Transactions

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "clock.fill").font(.system(size: 14)).foregroundColor(.appSecondary)
                    Text("Lịch sử giao dịch").font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.white)
                }
                Spacer()
                Button("Tất cả") { }.font(.system(size: 14, weight: .semibold)).foregroundColor(.appSecondary)
            }
            .padding(.horizontal, AppSpacing.xl).padding(.bottom, AppSpacing.md)

            VStack(spacing: 0) {
                ForEach(Array(vm.transactions.enumerated()), id: \.element.id) { i, tx in
                    TxRow(tx: tx)
                    if i < vm.transactions.count - 1 {
                        Rectangle().fill(Color.appPrimary.opacity(0.10)).frame(height: 1)
                            .padding(.leading, 74).padding(.trailing, AppSpacing.lg)
                    }
                }
            }
            .background(Color.spaceCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .overlay(RoundedRectangle(cornerRadius: AppRadius.lg).stroke(Color.appPrimary.opacity(0.18), lineWidth: 1))
            .appCardShadow()
            .padding(.horizontal, AppSpacing.lg)
        }
    }
}

// MARK: - Service Cell

struct CosmicServiceCell: View {
    let service: ServiceItem
    @State private var pressed = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) { pressed = true }
            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.3))
                pressed = false
            }
        } label: {
            VStack(spacing: 9) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16).fill(service.color.opacity(0.15)).frame(width: 56, height: 56)
                            .overlay(RoundedRectangle(cornerRadius: 16).stroke(service.color.opacity(0.28), lineWidth: 1))
                        Image(systemName: service.icon).font(.system(size: 22, weight: .semibold)).foregroundColor(service.color)
                    }
                    .cosmicGlow(color: service.color, radius: pressed ? 12 : 4)
                    .scaleEffect(pressed ? 0.91 : 1.0)

                    if let badge = service.badge {
                        Text(badge).font(.system(size: 7, weight: .black)).foregroundColor(.white)
                            .padding(.horizontal, 4).padding(.vertical, 2)
                            .background(Capsule().fill(Color.appRed))
                            .offset(x: 7, y: -4)
                    }
                }
                Text(service.title)
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(Color(white: 0.72))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
    }
}

// MARK: - Transaction Row

struct TxRow: View {
    let tx: Transaction

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle().fill(tx.iconColor.opacity(0.15)).frame(width: 48)
                    .overlay(Circle().stroke(tx.iconColor.opacity(0.22), lineWidth: 1))
                Image(systemName: tx.icon).font(.system(size: 17, weight: .semibold)).foregroundColor(tx.iconColor)
            }.cosmicGlow(color: tx.iconColor, radius: 4)

            VStack(alignment: .leading, spacing: 3) {
                Text(tx.title).font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                Text(tx.subtitle).font(.system(size: 12)).foregroundColor(Color(white: 0.52))
                Text(tx.date).font(.system(size: 11)).foregroundColor(Color(white: 0.36))
            }
            Spacer()

            Text(tx.isCredit ? "+\(tx.amount.vndFormatted)" : "-\(tx.amount.vndFormatted)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(tx.isCredit ? .appGreen : Color(white: 0.78))
        }
        .padding(.horizontal, AppSpacing.lg).padding(.vertical, 13)
    }
}

#Preview {
    HomeView().environmentObject(HomeViewModel())
}
