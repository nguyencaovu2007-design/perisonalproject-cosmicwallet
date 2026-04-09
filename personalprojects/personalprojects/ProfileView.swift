import SwiftUI
 
struct ProfileView: View {
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                // Header
                ZStack(alignment: .bottom) {
                    LinearGradient(
                        colors: [Color.momoRed, Color.momoPink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea(edges: .top)
 
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 130)
                        .offset(x: 130, y: -50)
 
                    VStack(spacing: 10) {
                        Spacer().frame(height: 50) 
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 76, height: 76)
                                .shadow(color: .black.opacity(0.15), radius: 10)
 
                            Text("VN")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.momoRed)
 
                            Circle()
                                .fill(Color.momoGreen)
                                .frame(width: 18, height: 18)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundColor(.white)
                                )
                                .offset(x: 26, y: 26)
                        }
 
                        Text("Vũ Cao Nguyên")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        Text("0912 345 678 · Đã xác thực ✓")
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .padding(.bottom, 20)
                }
 
                // Stats row
                HStack(spacing: 0) {
                    statItem(title: "Giao dịch", value: "248")
                    Divider().frame(height: 36)
                    statItem(title: "Bạn bè", value: "52")
                    Divider().frame(height: 36)
                    statItem(title: "Điểm MoMo", value: "1.850")
                }
                .padding(.vertical, 16)
                .background(Color.white)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
 
                VStack(spacing: 12) {
                    // Account section
                    menuSection(title: "Tài khoản", items: [
                        MenuRow(icon: "person.fill", color: .momoRed, title: "Thông tin cá nhân", subtitle: nil),
                        MenuRow(icon: "creditcard.fill", color: .momoBlue, title: "Liên kết ngân hàng", subtitle: "3 tài khoản"),
                        MenuRow(icon: "lock.fill", color: Color(red: 0.52, green: 0.28, blue: 0.90), title: "Bảo mật", subtitle: nil),
                    ])
 
                    // Settings section
                    menuSection(title: "Cài đặt", items: [
                        MenuRow(icon: "bell.badge.fill", color: .momoRed, title: "Thông báo", subtitle: nil),
                        MenuRow(icon: "globe", color: .momoGreen, title: "Ngôn ngữ", subtitle: "Tiếng Việt"),
                        MenuRow(icon: "moon.fill", color: Color(red: 0.20, green: 0.20, blue: 0.40), title: "Giao diện", subtitle: "Sáng"),
                    ])
 
                    // Support section
                    menuSection(title: "Hỗ trợ", items: [
                        MenuRow(icon: "questionmark.circle.fill", color: Color(red: 0.99, green: 0.62, blue: 0.07), title: "Trung tâm trợ giúp", subtitle: nil),
                        MenuRow(icon: "headphones", color: .momoBlue, title: "Liên hệ CSKH", subtitle: "1900 54 54 41"),
                        MenuRow(icon: "star.fill", color: Color.yellow, title: "Đánh giá ứng dụng", subtitle: nil),
                    ])
 
                    // Logout
                    Button {
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 15))
                            Text("Đăng xuất")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                        }
                        .foregroundColor(.momoRed)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 16)
 
                    Text("E-Wallet Banking v3.12.1 · Bản quyền © 2026")
                        .font(.system(size: 12))
                        .foregroundColor(.momoGray.opacity(0.6))
                        .padding(.bottom, 100)
                }
                .padding(.top, 16)
            }
        }
        .background(Color.momoLightGray.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
    }
 
    private func statItem(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.momoDark)
            Text(title)
                .font(.system(size: 12))
                .foregroundColor(.momoGray)
        }
        .frame(maxWidth: .infinity)
    }
 
    private func menuSection(title: String, items: [MenuRow]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.momoGray)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
 
            VStack(spacing: 0) {
                ForEach(items) { item in
                    menuRow(item)
                    if item.id != items.last?.id {
                        Divider().padding(.leading, 60)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .padding(.horizontal, 16)
    }
 
    private func menuRow(_ item: MenuRow) -> some View {
        Button {
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(item.color.opacity(0.14))
                        .frame(width: 36, height: 36)
                    Image(systemName: item.icon)
                        .font(.system(size: 15))
                        .foregroundColor(item.color)
                }
 
                Text(item.title)
                    .font(.system(size: 15))
                    .foregroundColor(.momoDark)
 
                Spacer()
 
                if let subtitle = item.subtitle {
                    Text(subtitle)
                        .font(.system(size: 13))
                        .foregroundColor(.momoGray)
                }
 
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.momoGray.opacity(0.5))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
    }
}
 
struct MenuRow: Identifiable {
    let id = UUID()
    let icon: String
    let color: Color
    let title: String
    let subtitle: String?
}
 
#Preview {
    ProfileView()
}
