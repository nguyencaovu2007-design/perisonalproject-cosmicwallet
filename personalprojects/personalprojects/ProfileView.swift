import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var vm: ProfileViewModel     // FIX: dùng ViewModel thay hardcode
    @State private var ringAngle = 0.0
    @State private var auraGlow  = false

    var body: some View {
        ZStack {
            NebulaBackground()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    profileHeader
                    statsRow
                    VStack(spacing: 14) {
                        section("🪐 Tài khoản", items: [
                            MenuRow(icon: "person.fill",     color: .appPrimary,  title: "Thông tin cá nhân",  subtitle: nil),
                            MenuRow(icon: "creditcard.fill", color: .cosmicCyan,  title: "Liên kết ngân hàng", subtitle: "3 tài khoản"),
                            MenuRow(icon: "lock.fill",       color: .cosmicPink,  title: "Bảo mật",            subtitle: nil),
                        ])
                        section("⚙️ Cài đặt", items: [
                            MenuRow(icon: "bell.badge.fill", color: .appOrange,  title: "Thông báo", subtitle: nil),
                            MenuRow(icon: "globe",           color: .appGreen,   title: "Ngôn ngữ",  subtitle: "Tiếng Việt"),
                            MenuRow(icon: "moon.stars.fill", color: .appPrimary, title: "Giao diện", subtitle: "Vũ trụ tối"),
                        ])
                        section("🌟 Hỗ trợ", items: [
                            MenuRow(icon: "questionmark.circle.fill", color: .appOrange,  title: "Trung tâm trợ giúp", subtitle: nil),
                            MenuRow(icon: "headphones",               color: .appPrimary, title: "Liên hệ CSKH",       subtitle: "1900 54 54 41"),
                            MenuRow(icon: "star.fill",                color: .cosmicGold, title: "Đánh giá ứng dụng",  subtitle: nil),
                        ])

                        // Logout
                        Button { } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Đăng xuất").font(.system(size: 15, weight: .semibold))
                                Spacer()
                            }
                            .foregroundColor(.appRed).padding(.vertical, 16)
                            .background(Color.spaceCard)
                            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                            .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.appRed.opacity(0.28), lineWidth: 1))
                        }
                        .buttonStyle(CosmicButtonStyle()).padding(.horizontal, AppSpacing.lg)

                        HStack(spacing: 5) {
                            Image(systemName: "sparkles").font(.system(size: 10)).foregroundColor(Color.cosmicGold.opacity(0.45))
                            Text("CosmicWallet v3.12.1 · © 2026 Deep Space Edition")
                                .font(.system(size: 11)).foregroundColor(Color(white: 0.28))
                        }.padding(.bottom, 110)
                    }
                    .padding(.top, AppSpacing.lg)
                }
            }
        }
        .ignoresSafeArea(edges: .top)
        .onAppear {
            withAnimation(.linear(duration: 10).repeatForever(autoreverses: false)) { ringAngle = 360 }
            withAnimation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true)) { auraGlow = true }
        }
    }

    // MARK: Header — FIX: dùng vm.initials, vm.userName, vm.phone, vm.isVerified

    private var profileHeader: some View {
        ZStack(alignment: .bottom) {
            CG.header.ignoresSafeArea(edges: .top)
            StarfieldView(starCount: 35).frame(height: 230).clipped()
            Circle()
                .fill(RadialGradient(colors: [Color.appPrimary.opacity(0.35), .clear],
                                      center: .center, startRadius: 0, endRadius: 90))
                .frame(width: 180).offset(x: 120, y: -60)
            Circle()
                .fill(RadialGradient(colors: [Color.cosmicPink.opacity(0.18), .clear],
                                      center: .center, startRadius: 0, endRadius: 70))
                .frame(width: 140).offset(x: -110, y: -20)

            VStack(spacing: 12) {
                Spacer().frame(height: 46)
                ZStack {
                    // Aura
                    Circle().fill(Color.appPrimary.opacity(auraGlow ? 0.18 : 0.04)).frame(width: 100)
                        .animation(.easeInOut(duration: 2.5).repeatForever(autoreverses: true), value: auraGlow)
                    // Rotating ring
                    Circle()
                        .stroke(AngularGradient(colors: [.appPrimary, .cosmicCyan, .cosmicPink, .cosmicGold, .appPrimary],
                                                 center: .center), lineWidth: 2.5)
                        .frame(width: 94).rotationEffect(.degrees(ringAngle))
                    // Avatar
                    Circle().fill(Color.spaceElevated).frame(width: 82)
                    Text(vm.initials)
                        .font(.system(size: 30, weight: .bold, design: .rounded)).foregroundColor(.appSecondary)
                    // Verified badge
                    if vm.isVerified {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.appGreen, .cosmicCyan], startPoint: .top, endPoint: .bottom))
                                .frame(width: 24)
                            Image(systemName: "checkmark").font(.system(size: 10, weight: .black)).foregroundColor(.white)
                        }
                        .cosmicGlow(color: .appGreen, radius: 6)
                        .offset(x: 30, y: 30)
                    }
                }

                Text(vm.userName)
                    .font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)

                HStack(spacing: 6) {
                    if vm.isVerified {
                        Image(systemName: "checkmark.seal.fill").font(.system(size: 12)).foregroundColor(.cosmicGold)
                    }
                    Text("\(vm.phone) · \(vm.isVerified ? "Đã xác thực" : "Chưa xác thực")")
                        .font(.system(size: 13, weight: .medium)).foregroundColor(Color(white: 0.62))
                }
            }.padding(.bottom, 28)
        }.frame(height: 240)
    }

    // MARK: Stats — FIX: dùng vm.transactionCount, vm.friendCount, vm.starPointsFormatted

    private var statsRow: some View {
        HStack(spacing: 0) {
            statItem("Giao dịch", value: "\(vm.transactionCount)", icon: "arrow.left.arrow.right", color: .appPrimary)
            Rectangle().fill(Color.appPrimary.opacity(0.18)).frame(width: 1, height: 44)
            statItem("Bạn bè",   value: "\(vm.friendCount)",       icon: "person.2.fill",          color: .cosmicCyan)
            Rectangle().fill(Color.appPrimary.opacity(0.18)).frame(width: 1, height: 44)
            statItem("Điểm sao", value: vm.starPointsFormatted,    icon: "star.fill",              color: .cosmicGold)
        }
        .padding(.vertical, 18)
        .background(Color.spaceCard)
        .shadow(color: Color.appPrimary.opacity(0.12), radius: 12, x: 0, y: 4)
    }

    private func statItem(_ title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 5) {
            Image(systemName: icon).font(.system(size: 13, weight: .semibold)).foregroundColor(color)
            Text(value).font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)
            Text(title).font(.system(size: 12, weight: .medium)).foregroundColor(Color(white: 0.48))
        }.frame(maxWidth: .infinity)
    }

    // MARK: Menu Section

    private func section(_ title: String, items: [MenuRow]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(Color(white: 0.42))
                .padding(.horizontal, AppSpacing.xl).padding(.bottom, AppSpacing.sm)
            VStack(spacing: 0) {
                ForEach(items) { item in
                    menuRow(item)
                    if item.id != items.last?.id {
                        Rectangle().fill(Color.appPrimary.opacity(0.10)).frame(height: 1).padding(.leading, 64)
                    }
                }
            }
            .background(Color.spaceCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
            .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.appPrimary.opacity(0.16), lineWidth: 1))
            .appCardShadow()
        }.padding(.horizontal, AppSpacing.lg)
    }

    private func menuRow(_ item: MenuRow) -> some View {
        Button { } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10).fill(item.color.opacity(0.15)).frame(width: 38, height: 38)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(item.color.opacity(0.25), lineWidth: 1))
                    Image(systemName: item.icon).font(.system(size: 15, weight: .semibold)).foregroundColor(item.color)
                }.cosmicGlow(color: item.color, radius: 4)
                Text(item.title).font(.system(size: 15)).foregroundColor(.white)
                Spacer()
                if let sub = item.subtitle {
                    Text(sub).font(.system(size: 13)).foregroundColor(Color(white: 0.45))
                }
                Image(systemName: "chevron.right").font(.system(size: 11, weight: .semibold)).foregroundColor(Color(white: 0.28))
            }
            .padding(.horizontal, AppSpacing.lg).padding(.vertical, 13)
        }.buttonStyle(CosmicButtonStyle())
    }
}

#Preview {
    ProfileView().environmentObject(ProfileViewModel())
}
