import SwiftUI

struct PaymentSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amount = ""
    @State private var selectedSourceToken = Token.mockTokens[0]
    @State private var selectedDestToken = Token.mockTokens[2]
    @State private var showingTokenPicker = false
    @State private var isSelectingSource = true
    @State private var isProcessing = false
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
                    
                    // Send Button
                    Button(action: processPayment) {
                        if isProcessing {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Send Payment")
                                .font(.headline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(amount.isEmpty ? Theme.secondary : Theme.primary)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .disabled(amount.isEmpty || isProcessing)
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
            .sheet(isPresented: $showingTokenPicker) {
                TokenPickerView(
                    selectedToken: isSelectingSource ? $selectedSourceToken : $selectedDestToken
                )
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
    
    private func processPayment() {
        isProcessing = true
        
        // Simulate payment processing
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            HapticManager.notification(type: .success)
            dismiss()
        }
    }
}

struct PaymentInputSection: View {
    let title: String
    @Binding var amount: String
    let token: Token
    let onTokenTap: () -> Void
    
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
                        Text(token.symbol)
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