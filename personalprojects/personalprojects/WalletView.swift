import SwiftUI

struct WalletView: View {
    @EnvironmentObject var vm: WalletViewModel
    @EnvironmentObject var homeVM: HomeViewModel          // FIX: lấy balance từ HomeViewModel
    @FocusState private var focused: Field?
    @State private var showBankPicker = false
    @State private var appeared       = false
    @State private var sendGlow       = false

    enum Field { case account, amount, note }

    var body: some View {
        ZStack {
            NebulaBackground()
            VStack(spacing: 0) {
                walletHeader
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        balanceCard.padding(.top, 8)
                        card("NGÂN HÀNG NHẬN")      { bankRow }
                        card("THÔNG TIN NGƯỜI NHẬN") { recipientSection }
                        card("SỐ TIỀN CHUYỂN")       { amountSection }
                        card("GHI CHÚ") {
                            HStack(spacing: 12) {
                                iconBox("text.bubble.fill", color: .cosmicCyan)
                                TextField("Nhập nội dung chuyển khoản...", text: $vm.note)
                                    .font(.system(size: 15)).foregroundColor(.white).tint(.appPrimary)
                                    .focused($focused, equals: .note)
                            }.padding(AppSpacing.lg)
                        }
                        recentContacts
                        sendButton.padding(.horizontal, AppSpacing.lg)
                        Spacer(minLength: 110)
                    }
                    .padding(.horizontal, AppSpacing.lg)
                    .opacity(appeared ? 1 : 0).offset(y: appeared ? 0 : 24)
                    .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1), value: appeared)
                }
            }
        }
        .sheet(isPresented: $showBankPicker) {
            BankPickerSheet(selected: $vm.selectedBank).presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $vm.showConfirmation) {
            ConfirmSheet(vm: vm).presentationDetents([.medium])
        }
        .onAppear {
            appeared = true
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) { sendGlow = true }
        }
        .onDisappear { appeared = false }
    }

    // MARK: Header

    private var walletHeader: some View {
        ZStack {
            CG.header
            StarfieldView(starCount: 30)
            Circle()
                .fill(RadialGradient(colors: [Color.cosmicPink.opacity(0.25), .clear],
                                      center: .center, startRadius: 0, endRadius: 70))
                .frame(width: 140).offset(x: 130, y: -20)
            VStack(spacing: 5) {
                Text("Chuyển tiền")
                    .font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)
                Text("Xuyên không gian · Tức thì · An toàn")
                    .font(.system(size: 12)).foregroundColor(Color(white: 0.55))
            }.padding(.top, 50).padding(.bottom, 20)
        }.frame(height: 118)
    }

    // MARK: Balance Card — FIX: dùng homeVM.displayBalance thay vì hardcode

    private var balanceCard: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 5) {
                    Image(systemName: "moon.stars.fill").font(.system(size: 11)).foregroundColor(.appSecondary)
                    Text("Số dư khả dụng").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(white: 0.55))
                }
                Text(homeVM.displayBalance)
                    .font(.system(size: 22, weight: .bold, design: .rounded)).foregroundColor(.white)
                    .animation(.spring(response: 0.3), value: homeVM.isBalanceHidden)
            }
            Spacer()
            Image(systemName: "wallet.pass.fill").font(.system(size: 28))
                .foregroundColor(.appPrimary).cosmicGlow(color: .appPrimary, radius: 8)
        }
        .padding(AppSpacing.lg).background(Color.spaceCard)
        .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
        .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.appPrimary.opacity(0.22), lineWidth: 1))
        .appCardShadow()
    }

    // MARK: Bank Row

    private var bankRow: some View {
        Button { showBankPicker = true } label: {
            HStack(spacing: 14) {
                if let b = vm.selectedBank {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(b.color.opacity(0.15)).frame(width: 38, height: 38)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(b.color.opacity(0.3), lineWidth: 1))
                        Image(systemName: b.icon).font(.system(size: 15)).foregroundColor(b.color)
                    }.cosmicGlow(color: b.color, radius: 4)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(b.name).font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                        Text(b.shortName).font(.system(size: 12)).foregroundColor(Color(white: 0.50))
                    }
                } else {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10).fill(Color.appPrimary.opacity(0.10)).frame(width: 38, height: 38)
                        Image(systemName: "building.columns.fill").font(.system(size: 15)).foregroundColor(Color(white: 0.40))
                    }
                    Text("Chọn ngân hàng...").font(.system(size: 15)).foregroundColor(Color(white: 0.35))
                }
                Spacer()
                Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(Color(white: 0.35))
            }.padding(AppSpacing.lg)
        }.buttonStyle(CosmicButtonStyle())
    }

    // MARK: Recipient Section — FIX: dùng vm.resolvedName thay vì hardcode "NGUYEN VAN AN"

    private var recipientSection: some View {
        VStack(spacing: 0) {
            HStack(spacing: 12) {
                iconBox("number.square.fill", color: .appPrimary)
                TextField("Số tài khoản / STK", text: $vm.recipientPhone)
                    .keyboardType(.numberPad)
                    .font(.system(size: 15)).foregroundColor(.white).tint(.appPrimary)
                    .focused($focused, equals: .account)
                    .onChange(of: vm.recipientPhone) { _, newValue in
                        vm.lookupName(for: newValue)
                    }
                if !vm.recipientPhone.isEmpty {
                    Button { vm.clearPhone() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(white: 0.38)).font(.system(size: 18))
                    }
                }
            }.padding(AppSpacing.lg)

            Rectangle().fill(Color.appPrimary.opacity(0.12)).frame(height: 1).padding(.leading, 52)

            HStack(spacing: 12) {
                iconBox("person.fill", color: .appGreen)
                if let name = vm.resolvedName {
                    Text(name)
                        .font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                        .transition(.opacity.combined(with: .move(edge: .leading)))
                } else {
                    Text("Tên người nhận")
                        .font(.system(size: 15)).foregroundColor(Color(white: 0.32))
                }
                Spacer()
                if vm.resolvedName != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.appGreen).font(.system(size: 18))
                        .cosmicGlow(color: .appGreen, radius: 6)
                        .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(AppSpacing.lg)
            .animation(.spring(response: 0.35), value: vm.resolvedName)
        }
    }

    // MARK: Amount Section

    private var amountSection: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center, spacing: 12) {
                iconBox("banknote.fill", color: .appPrimary)
                TextField("0", text: Binding(
                    get: { vm.rawAmount.isEmpty ? "" : vm.formatted(vm.rawAmount) },
                    set: { vm.rawAmount = $0.filter { $0.isNumber } }
                ))
                .keyboardType(.numberPad)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundColor(vm.rawAmount.isEmpty ? Color(white: 0.32) : .white)
                .tint(.appPrimary).focused($focused, equals: .amount)

                Text("đ").font(.system(size: 20, weight: .semibold)).foregroundColor(Color(white: 0.38))
            }.padding(AppSpacing.lg)

            Rectangle().fill(Color.appPrimary.opacity(0.12)).frame(height: 1).padding(.leading, 52)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                ForEach(vm.quickAmounts, id: \.self) { a in
                    let sel = vm.isSelected(a)
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { vm.selectQuick(a) }
                        focused = nil
                    } label: {
                        Text(a.vndCompact).font(.system(size: 12, weight: .bold))
                            .foregroundColor(sel ? .white : .appSecondary)
                            .padding(.vertical, 11).frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 10).fill(
                                sel ? CG.button : LinearGradient(
                                    colors: [Color.appPrimary.opacity(0.12), Color.cosmicBlue.opacity(0.08)],
                                    startPoint: .leading, endPoint: .trailing)
                            ))
                            .overlay(RoundedRectangle(cornerRadius: 10)
                                .stroke(sel ? Color.appSecondary.opacity(0.45) : Color.appPrimary.opacity(0.18), lineWidth: 1))
                    }
                    .buttonStyle(CosmicButtonStyle())
                    .cosmicGlow(color: sel ? .appPrimary : .clear, radius: sel ? 5 : 0)
                }
            }.padding(AppSpacing.lg)
        }
    }

    // MARK: Recent Contacts

    private var recentContacts: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                HStack(spacing: 5) {
                    Image(systemName: "person.2.fill").font(.system(size: 13)).foregroundColor(.appSecondary)
                    Text("Đã chuyển gần đây").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                }
                Spacer()
                Button("Tất cả") { }.font(.system(size: 13, weight: .semibold)).foregroundColor(.appSecondary)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.recentContacts) { c in
                        let sel = vm.selectedContact == c
                        Button {
                            withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) { vm.selectContact(c) }
                        } label: {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle().fill(c.color.opacity(0.15)).frame(width: 58)
                                        .overlay(Circle().stroke(c.color.opacity(sel ? 0.9 : 0.28), lineWidth: sel ? 2.5 : 1))
                                    if sel { Circle().fill(c.color.opacity(0.20)).frame(width: 58) }
                                    Text(c.initials).font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(c.color)
                                }
                                .cosmicGlow(color: sel ? c.color : .clear, radius: sel ? 8 : 0)
                                .scaleEffect(sel ? 1.08 : 1.0)
                                .animation(.spring(response: 0.3), value: sel)

                                Text(c.name).font(.system(size: 11, weight: .semibold)).foregroundColor(sel ? .white : Color(white: 0.62))
                                Text(c.phone).font(.system(size: 9)).foregroundColor(Color(white: 0.36))
                            }.frame(width: 70)
                        }.buttonStyle(CosmicButtonStyle())
                    }
                }.padding(.vertical, 4)
            }
        }
    }

    // MARK: Send Button

    private var sendButton: some View {
        Button {
            focused = nil
            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) { vm.showConfirmation = true }
        } label: {
            ZStack {
                if vm.canProceed {
                    RoundedRectangle(cornerRadius: AppRadius.md).fill(CG.button)
                        .blur(radius: sendGlow ? 12 : 6).opacity(0.5)
                        .scaleEffect(sendGlow ? 1.02 : 0.98)
                        .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: sendGlow)
                }
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(vm.canProceed
                          ? CG.button
                          : LinearGradient(colors: [Color(white: 0.14), Color(white: 0.11)], startPoint: .leading, endPoint: .trailing))
                    .overlay(RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(vm.canProceed ? Color.appSecondary.opacity(0.35) : .clear, lineWidth: 1))
                HStack(spacing: 10) {
                    Image(systemName: "paperplane.fill").font(.system(size: 16, weight: .bold))
                    Text("Chuyển tiền ngay").font(.system(size: 17, weight: .bold, design: .rounded))
                    if vm.canProceed { Image(systemName: "sparkles").font(.system(size: 14, weight: .bold)) }
                }
                .foregroundColor(vm.canProceed ? .white : Color(white: 0.32))
                .padding(.vertical, 17)
            }
            .frame(maxWidth: .infinity).frame(height: 56)
        }
        .disabled(!vm.canProceed)
        .animation(.spring(response: 0.3), value: vm.canProceed)
        .buttonStyle(CosmicButtonStyle())
    }

    // MARK: Helpers

    private func iconBox(_ name: String, color: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9).fill(color.opacity(0.15)).frame(width: 34, height: 34)
                .overlay(RoundedRectangle(cornerRadius: 9).stroke(color.opacity(0.25), lineWidth: 1))
            Image(systemName: name).font(.system(size: 14, weight: .semibold)).foregroundColor(color)
        }
    }

    private func card<C: View>(_ title: String, @ViewBuilder content: () -> C) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title).font(.system(size: 12, weight: .bold)).foregroundColor(Color(white: 0.48))
                .padding(.horizontal, 4).padding(.bottom, AppSpacing.sm)
            VStack(spacing: 0) { content() }
                .background(Color.spaceCard)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.appPrimary.opacity(0.18), lineWidth: 1))
                .appCardShadow()
        }
    }
}

// MARK: - BankPickerSheet

struct BankPickerSheet: View {
    @Binding var selected: BankItem?
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.spaceDark.ignoresSafeArea()
            StarfieldView(starCount: 30)
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 3).fill(Color.appPrimary.opacity(0.5))
                    .frame(width: 40, height: 4).padding(.top, 12)
                Text("Chọn ngân hàng")
                    .font(.system(size: 18, weight: .bold, design: .rounded)).foregroundColor(.white).padding(.vertical, 16)
                Rectangle().fill(Color.appPrimary.opacity(0.15)).frame(height: 1)
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(MoMoData.banks) { b in
                            Button {
                                withAnimation(.spring(response: 0.35)) { selected = b }
                                dismiss()
                            } label: {
                                HStack(spacing: 16) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12).fill(b.color.opacity(0.15)).frame(width: 46, height: 46)
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(b.color.opacity(0.3), lineWidth: 1))
                                        Image(systemName: b.icon).font(.system(size: 18)).foregroundColor(b.color)
                                    }.cosmicGlow(color: b.color, radius: 4)
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(b.name).font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                                        Text(b.shortName).font(.system(size: 12)).foregroundColor(Color(white: 0.48))
                                    }
                                    Spacer()
                                    if selected?.id == b.id {
                                        Image(systemName: "checkmark.circle.fill").font(.system(size: 22))
                                            .foregroundColor(.appPrimary).cosmicGlow(color: .appPrimary, radius: 6)
                                    }
                                }
                                .padding(.horizontal, AppSpacing.xl).padding(.vertical, 14)
                            }.buttonStyle(CosmicButtonStyle())

                            if b.id != MoMoData.banks.last?.id {
                                Rectangle().fill(Color.appPrimary.opacity(0.10)).frame(height: 1).padding(.leading, 78)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - ConfirmSheet — FIX: dùng vm.resolvedName thay vì hardcode

struct ConfirmSheet: View {
    @ObservedObject var vm: WalletViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.spaceDark.ignoresSafeArea()
            StarfieldView(starCount: 25)
            VStack(spacing: 22) {
                RoundedRectangle(cornerRadius: 3).fill(Color.appPrimary.opacity(0.5))
                    .frame(width: 40, height: 4).padding(.top, 12)

                ZStack {
                    Circle().fill(Color.appPrimary.opacity(0.15)).frame(width: 80)
                    Image(systemName: "paperplane.fill").font(.system(size: 32, weight: .semibold)).foregroundColor(.appSecondary)
                }.cosmicGlow(color: .appPrimary, radius: 20)

                Text("Xác nhận chuyển tiền")
                    .font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white)

                VStack(spacing: 10) {
                    confirmRow("Người nhận",   vm.resolvedName ?? "Không xác định")
                    confirmRow("Số tài khoản", vm.recipientPhone)
                    confirmRow("Số tiền",      (vm.amountValue ?? 0).vndFormatted)
                    if !vm.note.isEmpty { confirmRow("Ghi chú", vm.note) }
                }.padding(.horizontal, 24)

                HStack(spacing: 12) {
                    Button { dismiss() } label: {
                        Text("Huỷ").font(.system(size: 16, weight: .semibold)).foregroundColor(Color(white: 0.62))
                            .frame(maxWidth: .infinity).padding(.vertical, 15)
                            .background(Color.spaceCard).clipShape(RoundedRectangle(cornerRadius: AppRadius.md))
                            .overlay(RoundedRectangle(cornerRadius: AppRadius.md).stroke(Color.appPrimary.opacity(0.22), lineWidth: 1))
                    }.buttonStyle(CosmicButtonStyle())

                    Button { dismiss() } label: {
                        Text("Xác nhận").font(.system(size: 16, weight: .bold, design: .rounded)).foregroundColor(.white)
                            .frame(maxWidth: .infinity).padding(.vertical, 15)
                            .background(RoundedRectangle(cornerRadius: AppRadius.md).fill(CG.button))
                            .appButtonShadow(color: .appPrimary)
                    }.buttonStyle(CosmicButtonStyle())
                }.padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    private func confirmRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label).font(.system(size: 14, weight: .medium)).foregroundColor(Color(white: 0.48))
            Spacer()
            Text(value).font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(.white)
        }
        .padding(.vertical, 12).padding(.horizontal, 16)
        .background(Color.spaceCard)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.appPrimary.opacity(0.14), lineWidth: 1))
    }
}

#Preview {
    WalletView()
        .environmentObject(WalletViewModel())
        .environmentObject(HomeViewModel())
}
