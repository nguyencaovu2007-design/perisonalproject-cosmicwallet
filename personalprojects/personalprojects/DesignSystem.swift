import SwiftUI
import Combine
 
// MARK: - Color System
 
extension Color {
    static let momoRed       = Color(red: 0.91, green: 0.11, blue: 0.29)
    static let momoPink      = Color(red: 0.96, green: 0.22, blue: 0.42)
    static let momoLightPink = Color(red: 1.0,  green: 0.88, blue: 0.91)
    static let momoDark      = Color(red: 0.10, green: 0.06, blue: 0.10)
    static let momoCardBg    = Color(red: 0.98, green: 0.97, blue: 0.98)
    static let momoGray      = Color(red: 0.55, green: 0.53, blue: 0.55)
    static let momoLightGray = Color(red: 0.95, green: 0.95, blue: 0.96)
    static let momoGreen     = Color(red: 0.15, green: 0.73, blue: 0.45)
    static let momoBlue      = Color(red: 0.18, green: 0.46, blue: 0.95)
}
 
// MARK: - Currency Formatter
 
extension Double {
    var vndFormatted: String {
        let abs = Swift.abs(Int(self))
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        let num = formatter.string(from: NSNumber(value: abs)) ?? "\(abs)"
        return "\(num) đ"
    }
}
 
extension String {
    var vndValue: Double? {
        let cleaned = self
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: " đ", with: "")
            .trimmingCharacters(in: .whitespaces)
        return Double(cleaned)
    }
}
 
// MARK: - Models
 
struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let amount: Double
    let isCredit: Bool
    let icon: String
    let iconColor: Color
    let date: String
}
 
struct ServiceItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let badge: String?
}
 
struct PromoItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
}
 
// MARK: - Mock Data
 
struct MoMoData {
    static let transactions: [Transaction] = [
        Transaction(title: "Nạp tiền điện thoại",   subtitle: "Viettel • 0987 654 321", amount: -100_000, isCredit: false, icon: "phone.fill",            iconColor: .momoRed,   date: "Hôm nay, 14:32"),
        Transaction(title: "Nhận tiền từ Minh Tuấn", subtitle: "Chuyển khoản",           amount:  500_000, isCredit: true,  icon: "arrow.down.left",        iconColor: .momoGreen, date: "Hôm nay, 11:15"),
        Transaction(title: "Thanh toán điện",        subtitle: "EVN TP.HCM",              amount: -215_000, isCredit: false, icon: "bolt.fill",              iconColor: .momoBlue,  date: "Hôm qua, 09:00"),
        Transaction(title: "Mua vé phim",            subtitle: "CGV Vincom",              amount: -160_000, isCredit: false, icon: "film.fill",              iconColor: .purple,    date: "Hôm qua, 20:45"),
        Transaction(title: "Hoàn tiền MoMo",         subtitle: "Ưu đãi hoàn tiền",        amount:   15_000, isCredit: true,  icon: "gift.fill",              iconColor: .momoRed,   date: "23/06, 00:01"),
        Transaction(title: "Grab - Đặt xe",          subtitle: "Grab Vietnam",            amount:  -45_000, isCredit: false, icon: "car.fill",               iconColor: .green,     date: "22/06, 18:22"),
        Transaction(title: "Chuyển tiền cho Lan",    subtitle: "Chuyển khoản",            amount: -200_000, isCredit: false, icon: "arrow.up.right",         iconColor: .momoRed,   date: "22/06, 12:00"),
    ]
 
    static let services: [ServiceItem] = [
        ServiceItem(title: "Nạp tiền",    icon: "phone.badge.plus",          color: .momoRed,                                  badge: nil),
        ServiceItem(title: "Chuyển tiền", icon: "arrow.left.arrow.right",    color: Color(red: 0.18, green: 0.46, blue: 0.95), badge: nil),
        ServiceItem(title: "Thanh toán",  icon: "qrcode",                    color: Color(red: 0.15, green: 0.73, blue: 0.45), badge: nil),
        ServiceItem(title: "Điện, nước",  icon: "bolt.fill",                 color: Color(red: 0.99, green: 0.62, blue: 0.07), badge: nil),
        ServiceItem(title: "Mua sắm",     icon: "bag.fill",                  color: Color(red: 0.90, green: 0.28, blue: 0.60), badge: "HOT"),
        ServiceItem(title: "Đặt vé",      icon: "ticket.fill",               color: Color(red: 0.52, green: 0.28, blue: 0.90), badge: nil),
        ServiceItem(title: "Bảo hiểm",   icon: "shield.fill",               color: Color(red: 0.07, green: 0.63, blue: 0.86), badge: nil),
        ServiceItem(title: "Đầu tư",      icon: "chart.line.uptrend.xyaxis", color: Color(red: 0.12, green: 0.76, blue: 0.55), badge: "MỚI"),
    ]
 
    static let promotions: [PromoItem] = [
        PromoItem(title: "Hoàn tiền 30%",       subtitle: "Thanh toán tại Highlands Coffee",  icon: "cup.and.saucer.fill",    color: .momoRed),
        PromoItem(title: "Giảm 50k",            subtitle: "Đặt xe Grab lần đầu qua MoMo",     icon: "car.fill",               color: .momoGreen),
        PromoItem(title: "Tặng 20k",            subtitle: "Nạp tiền điện thoại từ 100k",      icon: "phone.fill",             color: .momoBlue),
        PromoItem(title: "0đ phí chuyển",       subtitle: "Chuyển tiền đến mọi ngân hàng",    icon: "arrow.left.arrow.right", color: .momoPink),
        PromoItem(title: "Hoàn tiền 15%",       subtitle: "Thanh toán tại Circle K, GS25",    icon: "cart.fill",              color: Color(red: 0.52, green: 0.28, blue: 0.90)),
        PromoItem(title: "Miễn phí vận chuyển", subtitle: "Mua hàng qua MoMo Mall",           icon: "shippingbox.fill",       color: Color(red: 0.99, green: 0.62, blue: 0.07)),
    ]
}
 
// MARK: - HomeViewModel
 
@MainActor
class HomeViewModel: ObservableObject {
    @Published var balance: Double = 555_555_555
    @Published var isBalanceHidden: Bool = false
    @Published var transactions: [Transaction] = MoMoData.transactions
    @Published var services: [ServiceItem] = MoMoData.services
    @Published var isRefreshing: Bool = false
    @Published var userName: String = "Vũ Cao Nguyên"
    @Published var hasNotification: Bool = true
 
    var displayBalance: String {
        isBalanceHidden ? "••••••••" : balance.vndFormatted
    }
 
    var initials: String {
        let parts = userName.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.last?.prefix(1) ?? ""
        return "\(first)\(last)"
    }
 
    func toggleBalance() {
        withAnimation(.spring(response: 0.3)) {
            isBalanceHidden.toggle()
        }
    }
 
    func refresh() async {
        isRefreshing = true
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        isRefreshing = false
    }
}
 
// MARK: - WalletViewModel
 
@MainActor
class WalletViewModel: ObservableObject {
    struct ContactItem: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let initials: String
        let phone: String
        let color: Color
        static func == (lhs: ContactItem, rhs: ContactItem) -> Bool { lhs.id == rhs.id }
    }
 
    @Published var rawAmount: String = ""
    @Published var recipientPhone: String = ""
    @Published var selectedContact: ContactItem? = nil
    @Published var showConfirmation: Bool = false
    @Published var note: String = ""
 
    let quickAmounts: [Double] = [50_000, 100_000, 200_000, 500_000, 1_000_000, 2_000_000]
 
    let recentContacts: [ContactItem] = [
        ContactItem(name: "Minh Tuấn", initials: "MT", phone: "0912 345 678", color: .momoBlue),
        ContactItem(name: "Thùy Lan",  initials: "TL", phone: "0987 654 321", color: .momoPink),
        ContactItem(name: "Hải Long",  initials: "HL", phone: "0901 234 567", color: .momoGreen),
        ContactItem(name: "Phương",    initials: "PT", phone: "0976 543 210", color: .purple),
    ]
 
    var amountValue: Double? { Double(rawAmount) }
 
    var canProceed: Bool {
        !recipientPhone.isEmpty && (amountValue ?? 0) > 0
    }
 
    func selectQuickAmount(_ amount: Double) {
        rawAmount = "\(Int(amount))"
    }
 
    func isQuickAmountSelected(_ amount: Double) -> Bool {
        amountValue == amount
    }
 
    func selectContact(_ contact: ContactItem) {
        selectedContact = contact
        recipientPhone = contact.phone
    }
 
    func clearPhone() {
        recipientPhone = ""
        selectedContact = nil
    }
 
    func formatDisplayAmount(_ raw: String) -> String {
        guard let val = Double(raw) else { return raw }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        return formatter.string(from: NSNumber(value: Int(val))) ?? raw
    }
}
 
// MARK: - ProfileViewModel
 
@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userName: String = "Vũ Cao Nguyên"
    @Published var phone: String = "0912 345 678"
    @Published var isVerified: Bool = true
    @Published var transactionCount: Int = 248
    @Published var friendCount: Int = 52
    @Published var momoPoints: Int = 1_850
    @Published var showLogoutAlert: Bool = false
    @Published var language: String = "Tiếng Việt"
    @Published var notificationEnabled: Bool = true
    @Published var isDarkMode: Bool = false
 
    var initials: String {
        let parts = userName.split(separator: " ")
        let first = parts.first?.prefix(1) ?? ""
        let last = parts.last?.prefix(1) ?? ""
        return "\(first)\(last)"
    }
 
    func logout() {
        // TODO: clear session, navigate to login
    }
}
