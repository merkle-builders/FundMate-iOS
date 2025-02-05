import SwiftUI

struct PaymentSheet: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var priceTracker = TokenPriceTracker()
    @State private var amount = ""
    @State private var note = ""
    @State private var selectedSourceToken = Token.mockTokens[0]
    @State private var selectedDestToken = Token.mockTokens[2]
    @State private var showingTokenPicker = false
    @State private var isSelectingSource = true
    @State private var showingConfirmation = false
    @State private var showingStatus = false
    @State private var transactionStatus: TransactionStatusView.TransactionStatus = .processing
    var receiverAddress: String?
    @State private var recipientAddress = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if receiverAddress == nil {
                        // Recipient Address Field
                        TextField("Recipient Address", text: $recipientAddress)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                    }
                    
                    // You Pay Section
                    PaymentInputSection(
                        title: "You Pay",
                        amount: $amount,
                        token: selectedSourceToken,
                        onTokenTap: { isSelectingSource = true; showingTokenPicker = true }
                    )
                    
                    // Conversion Arrow
                    Image(systemName: "arrow.down")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    
                    // They Receive Section
                    PaymentInputSection(
                        title: "They Receive",
                        amount: .constant(convertedAmount),
                        token: selectedDestToken,
                        onTokenTap: { isSelectingSource = false; showingTokenPicker = true }
                    )
                    
                    // Note Field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note (optional)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        TextField("What's this payment for?", text: $note)
                            .textFieldStyle(.roundedBorder)
                            .font(.subheadline)
                    }
                    .padding(.horizontal)
                    
                    // Send Button
                    Button(action: showConfirmation) {
                        Text("Send Payment")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(amount.isEmpty ? Theme.secondary : Theme.primary)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(amount.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Send Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .sheet(isPresented: $showingConfirmation) {
                PaymentConfirmationSheet(
                    amount: Double(amount) ?? 0,
                    sourceToken: selectedSourceToken,
                    destToken: selectedDestToken,
                    recipientAddress: receiverAddress ?? recipientAddress,
                    note: note.isEmpty ? nil : note,
                    onConfirm: processPayment
                )
            }
            .sheet(isPresented: $showingTokenPicker) {
                TokenPickerView(
                    selectedToken: isSelectingSource ? $selectedSourceToken : $selectedDestToken
                )
            }
            .overlay {
                if showingStatus {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .overlay {
                            TransactionStatusView(
                                status: transactionStatus,
                                onDismiss: handleStatusDismiss
                            )
                        }
                }
            }
            .onAppear {
                if let address = receiverAddress {
                    recipientAddress = address
                }
            }
        }
    }
    
    private var convertedAmount: String {
        guard let sourceAmount = Double(amount) else { return "" }
        let convertedValue = sourceAmount * (selectedSourceToken.currentPrice / selectedDestToken.currentPrice)
        return String(format: "%.2f", convertedValue)
    }
    
    private func showConfirmation() {
        HapticManager.selection()
        showingConfirmation = true
    }
    
    private func processPayment() {
        Task {
            do {
                // Authenticate user
                let authenticated = try await BiometricAuthManager.authenticate(
                    reason: "Confirm payment of \(amount) \(selectedSourceToken.symbol)"
                )
                
                guard authenticated else { return }
                
                await MainActor.run {
                    showingConfirmation = false
                    showingStatus = true
                    transactionStatus = .processing
                }
                
                // Simulate payment processing
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                // Simulate success (80% chance) or failure
                if Double.random(in: 0...1) < 0.8 {
                    await MainActor.run {
                        transactionStatus = .success
                        HapticManager.paymentSuccess()
                    }
                } else {
                    throw NSError(domain: "Payment", code: 1, userInfo: [
                        NSLocalizedDescriptionKey: "Transaction failed. Please try again."
                    ])
                }
                
            } catch {
                await MainActor.run {
                    transactionStatus = .failure(error)
                    HapticManager.paymentFailed()
                }
            }
        }
    }
    
    private func handleStatusDismiss() {
        if case .success = transactionStatus {
            dismiss()
        } else {
            showingStatus = false
        }
    }
}

struct PaymentInputSection: View {
    let title: String
    @Binding var amount: String
    let token: Token
    let onTokenTap: () -> Void
    @EnvironmentObject private var priceTracker: TokenPriceTracker
    
    private var tokenPrice: Double {
        priceTracker.prices[token.symbol] ?? token.currentPrice
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack {
                if title == "You Pay" {
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                        .font(.title2)
                } else {
                    Text(amount.isEmpty ? "0.00" : amount)
                        .font(.title2)
                        .foregroundStyle(amount.isEmpty ? .secondary : .primary)
                }
                
                Spacer()
                
                Button(action: onTokenTap) {
                    HStack {
                        Image(systemName: token.iconName)
                        VStack(alignment: .leading) {
                            Text(token.symbol)
                            Text("$\(tokenPrice, specifier: "%.2f")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Image(systemName: "chevron.down")
                    }
                    .padding(8)
                    .background(Theme.secondaryBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8)
    }
}

struct TokenPickerView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedToken: Token
    
    var body: some View {
        NavigationStack {
            List(Token.mockTokens) { token in
                Button(action: { selectedToken = token; dismiss() }) {
                    HStack {
                        Image(systemName: token.iconName)
                            .font(.title2)
                        
                        VStack(alignment: .leading) {
                            Text(token.name)
                                .font(.headline)
                            Text(token.symbol)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        if token.id == selectedToken.id {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Theme.primary)
                        }
                    }
                }
            }
            .navigationTitle("Select Token")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
} 