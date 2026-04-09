import SwiftUI

struct HomeView: View {
    @EnvironmentObject var vm: HomeViewModel

    var body: some View {
        ZStack(alignment: .top) {
            Color.momoCardBg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .zIndex(1)

                    balanceCard
                        .padding(.horizontal, 16)
                        .offset(y: -20)

                    servicesSection
                        .padding(.top, 4)

                    promoBanner
                        .padding(.horizontal, 16)
                        .padding(.top, 16)

                    transactionsSection
                        .padding(.top, 16)

                    Spacer(minLength: 100)
                }
            }
            .refreshable {
                await vm.refresh()
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color.momoRed, Color.momoPink, Color(red: 0.95, green: 0.15, blue: 0.40)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea(edges: .top)
            .cornerRadius(20)
            .padding(.horizontal, 13)

            Circle()
                .fill(Color.white.opacity(0.08))
                .frame(width: 160)
                .offset(x: 130, y: -40)

            Circle()
                .fill(Color.white.opacity(0.06))
                .frame(width: 100)
                .offset(x: -140, y: 50)

            HStack(alignment: .center) {
                HStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 44, height: 44)
                        Text(vm.initials)
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .accessibilityHidden(true)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Xin chào")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.85))
                        Text(vm.userName)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    }
                }

                Spacer()

                HStack(spacing: 16) {
                    Button {
                        vm.hasNotification = false
                    } label: {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                            if vm.hasNotification {
                                Circle()
                                    .fill(Color.yellow)
                                    .frame(width: 8, height: 8)
                                    .offset(x: 2, y: -2)
                            }
                        }
                    }
                    .accessibilityLabel(vm.hasNotification ? "Thông báo, có tin mới" : "Thông báo")

                    Button { } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    .accessibilityLabel("Tìm kiếm")
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 110)
        .padding(.bottom, 50)
    }

    // MARK: - Balance Card

    private var balanceCard: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Text("Số dư ví")
                            .font(.system(size: 13))
                            .foregroundColor(.momoGray)
                        Button {
                            vm.toggleBalance()
                        } label: {
                            Image(systemName: vm.isBalanceHidden ? "eye.slash.fill" : "eye.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.momoGray)
                        }
                        .accessibilityLabel(vm.isBalanceHidden ? "Hiện số dư" : "Ẩn số dư")
                    }

                    Text(vm.displayBalance)
                        .font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundColor(.momoDark)
                        .animation(.spring(response: 0.3), value: vm.isBalanceHidden)
                        .accessibilityLabel(vm.isBalanceHidden ? "Số dư đã ẩn" : "Số dư \(vm.displayBalance)")
                }

                Spacer()

                Button { } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.momoLightPink)
                                .frame(width: 52, height: 52)
                            Image(systemName: "qrcode.viewfinder")
                                .font(.system(size: 24))
                                .foregroundColor(.momoRed)
                        }
                        Text("Mã QR")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.momoRed)
                    }
                }
                .accessibilityLabel("Mã QR của tôi")
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)

            Divider()
                .padding(.horizontal, 20)
                .padding(.vertical, 14)

            HStack(spacing: 0) {
                quickActionButton(icon: "arrow.up.right",       title: "Chuyển",   color: .momoRed)
                quickActionButton(icon: "arrow.down.left",      title: "Nhận",     color: .momoBlue)
                quickActionButton(icon: "plus.circle.fill",     title: "Nạp ví",   color: .momoGreen)
                quickActionButton(icon: "dollarsign.circle.fill", title: "Rút tiền", color: Color(red: 0.99, green: 0.62, blue: 0.07))
            }
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.08), radius: 16, x: 0, y: 6)
    }

    private func quickActionButton(icon: String, title: String, color: Color) -> some View {
        Button { } label: {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.12))
                        .frame(width: 46, height: 46)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(color)
                }
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.momoDark)
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityLabel(title)
    }

    // MARK: - Services Section

    private var servicesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Dịch vụ")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.momoDark)
                    .padding(.leading, 20)
                Spacer()
                Button("Xem thêm") { }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.momoRed)
                    .padding(.trailing, 20)
                    .accessibilityLabel("Xem thêm dịch vụ")
            }

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4),
                spacing: 16
            ) {
                ForEach(vm.services) { service in
                    ServiceCell(service: service)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(Color.white)
    }

    // MARK: - Promo Banner

    private var promoBanner: some View {
        ZStack(alignment: .leading) {
            LinearGradient(
                colors: [Color(red: 0.95, green: 0.15, blue: 0.40), Color(red: 0.65, green: 0.10, blue: 0.60)],
                startPoint: .leading,
                endPoint: .trailing
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Circle()
                .fill(Color.white.opacity(0.10))
                .frame(width: 80)
                .offset(x: 250, y: 0)

            HStack(spacing: 12) {
                Image(systemName: "gift.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text("Hoàn tiền 20%")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Text("Khi thanh toán tại cửa hàng tiện lợi")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.85))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(14)
        }
        .frame(height: 72)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Ưu đãi: Hoàn tiền 20% khi thanh toán tại cửa hàng tiện lợi")
    }

    // MARK: - Transactions Section

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Lịch sử giao dịch")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.momoDark)
                Spacer()
                Button("Tất cả") { }
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.momoRed)
                    .accessibilityLabel("Xem tất cả giao dịch")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)

            VStack(spacing: 0) {
                ForEach(Array(vm.transactions.enumerated()), id: \.element.id) { idx, tx in
                    TransactionRow(transaction: tx)
                    if idx < vm.transactions.count - 1 {
                        Divider().padding(.leading, 72)
                    }
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 4)
            .padding(.horizontal, 16)
        }
    }
}

// MARK: - Service Cell

struct ServiceCell: View {
    let service: ServiceItem

    var body: some View {
        Button { } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(service.color.opacity(0.12))
                            .frame(width: 52, height: 52)
                        Image(systemName: service.icon)
                            .font(.system(size: 22))
                            .foregroundColor(service.color)
                    }

                    if let badge = service.badge {
                        Text(badge)
                            .font(.system(size: 7, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.momoRed)
                            .clipShape(Capsule())
                            .offset(x: 6, y: -4)
                    }
                }

                Text(service.title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.momoDark)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .accessibilityLabel(service.badge != nil ? "\(service.title), \(service.badge!)" : service.title)
    }
}

// MARK: - Transaction Row

struct TransactionRow: View {
    let transaction: Transaction

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(transaction.iconColor.opacity(0.12))
                    .frame(width: 44, height: 44)
                Image(systemName: transaction.icon)
                    .font(.system(size: 17))
                    .foregroundColor(transaction.iconColor)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 3) {
                Text(transaction.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.momoDark)
                Text(transaction.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.momoGray)
                Text(transaction.date)
                    .font(.system(size: 11))
                    .foregroundColor(.momoGray.opacity(0.7))
            }

            Spacer()

            Text(transaction.isCredit
                 ? "+\(transaction.amount.vndFormatted)"
                 : transaction.amount.vndFormatted)
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(transaction.isCredit ? .momoGreen : .momoDark)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(transaction.title), \(transaction.isCredit ? "+" : "")\(transaction.amount.vndFormatted), \(transaction.date)")
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeViewModel())
}
