import SwiftUI

struct WalletView: View {
    @EnvironmentObject var vm: WalletViewModel
    @FocusState private var amountFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            // Header
            ZStack {
                LinearGradient(
                    colors: [Color.momoRed, Color.momoPink],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 120,height: 90)
                    .offset(x: 140, y: -20)

                VStack(spacing: 5) {
                    Text("Chuyển tiền")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text("Nhập số điện thoại hoặc chọn từ danh bạ")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top, 50)
                .padding(.bottom, 20)
            }
            .frame(height: 120)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Input card
                    inputCard
                        .offset(y: -24)

                    // Quick amounts
                    quickAmountsSection
                        .offset(y: -16)

                    // Recent contacts
                    recentContactsSection
                        .offset(y: -8)

                    // Note field
                    noteField

                    // CTA Button
                    proceedButton

                    Spacer(minLength: 80)
                }
                .padding(.top, 8)
            }
        }
        .background(Color.momoLightGray.ignoresSafeArea())
        .ignoresSafeArea(edges: .top)
        .alert("Xác nhận chuyển tiền", isPresented: $vm.showConfirmation) {
            Button("Huỷ", role: .cancel) { }
            Button("Xác nhận") { }
        } message: {
            Text("Chuyển \(vm.formatDisplayAmount(vm.rawAmount)) đ đến \(vm.recipientPhone)")
        }
    }

    // MARK: - Input Card

    private var inputCard: some View {
        VStack(spacing: 0) {
            // Phone field
            HStack(spacing: 12) {
                Image(systemName: "phone.fill")
                    .foregroundColor(.momoRed)
                    .font(.system(size: 16))
                    .frame(width: 24)
                    .accessibilityHidden(true)

                TextField("Số điện thoại người nhận", text: $vm.recipientPhone)
                    .keyboardType(.numberPad)
                    .font(.system(size: 15))
                    .accessibilityLabel("Số điện thoại người nhận")

                if !vm.recipientPhone.isEmpty {
                    Button {
                        vm.clearPhone()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.momoGray)
                    }
                    .accessibilityLabel("Xóa số điện thoại")
                }
            }
            .padding(16)

            Divider().padding(.leading, 52)

            // Amount field
            HStack(spacing: 12) {
                Image(systemName: "banknote.fill")
                    .foregroundColor(.momoRed)
                    .font(.system(size: 16))
                    .frame(width: 24)
                    .accessibilityHidden(true)

                // Hiển thị số có dấu chấm trong TextField
                TextField("Số tiền", text: Binding(
                    get: {
                        vm.rawAmount.isEmpty ? "" : vm.formatDisplayAmount(vm.rawAmount)
                    },
                    set: { newVal in
                        // Strip dấu chấm, chỉ lưu số thuần
                        let digits = newVal.filter { $0.isNumber }
                        vm.rawAmount = digits
                    }
                ))
                .keyboardType(.numberPad)
                .font(.system(size: 15))
                .focused($amountFocused)
                .accessibilityLabel("Số tiền cần chuyển")

                Text("đ")
                    .foregroundColor(.momoGray)
                    .font(.system(size: 15, weight: .medium))
            }
            .padding(16)
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.07), radius: 12, x: 0, y: 4)
        .padding(.horizontal, 16)
    }

    // MARK: - Quick Amounts

    private var quickAmountsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Số tiền nhanh")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.momoGray)
                .padding(.horizontal, 4)

            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible()),
            ], spacing: 10) {
                ForEach(vm.quickAmounts, id: \.self) { amount in
                    let isSelected = vm.isQuickAmountSelected(amount)
                    Button {
                        vm.selectQuickAmount(amount)
                        amountFocused = false
                    } label: {
                        Text(amount.vndFormatted)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(isSelected ? .white : .momoRed)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(isSelected ? Color.momoRed : Color.momoLightPink)
                            )
                    }
                    .accessibilityLabel("\(amount.vndFormatted)\(isSelected ? ", đang chọn" : "")")
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Recent Contacts

    private var recentContactsSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Gần đây")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.momoDark)
                Spacer()
                Button("Tất cả") { }
                    .font(.system(size: 13))
                    .foregroundColor(.momoRed)
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(vm.recentContacts) { contact in
                        let isSelected = vm.selectedContact == contact
                        Button {
                            vm.selectContact(contact)
                        } label: {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(contact.color.opacity(0.18))
                                        .frame(width: 52, height: 52)
                                        .overlay(
                                            Circle()
                                                .stroke(isSelected ? contact.color : Color.clear, lineWidth: 2.5)
                                        )
                                    Text(contact.initials)
                                        .font(.system(size: 17, weight: .bold))
                                        .foregroundColor(contact.color)
                                }
                                Text(contact.name)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.momoDark)
                            }
                        }
                        .accessibilityLabel("\(contact.name), \(contact.phone)\(isSelected ? ", đang chọn" : "")")
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }

    // MARK: - Note Field

    private var noteField: some View {
        HStack(spacing: 12) {
            Image(systemName: "note.text")
                .foregroundColor(.momoRed)
                .font(.system(size: 16))
                .frame(width: 24)
                .accessibilityHidden(true)

            TextField("Lời nhắn (tuỳ chọn)", text: $vm.note)
                .font(.system(size: 15))
                .accessibilityLabel("Lời nhắn")
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 3)
        .padding(.horizontal, 16)
    }

    // MARK: - Proceed Button

    private var proceedButton: some View {
        Button {
            amountFocused = false
            vm.showConfirmation = true
        } label: {
            HStack {
                Spacer()
                Text("Tiếp tục")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.momoRed, Color.momoPink],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.momoRed.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 16)
        .disabled(!vm.canProceed)
        .opacity(vm.canProceed ? 1 : 0.5)
        .accessibilityLabel("Tiếp tục chuyển tiền")
        .accessibilityHint(vm.canProceed ? "" : "Vui lòng nhập số điện thoại và số tiền")
    }
}

#Preview {
    WalletView()
        .environmentObject(WalletViewModel())
}
