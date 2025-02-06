import SwiftUI

enum TimeFrame: String, CaseIterable {
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case all = "All"
}

struct PaymentsView: View {
    @EnvironmentObject private var priceTracker: TokenPriceTracker
    
    // Mock holdings data - in real app this would come from a wallet/backend
    let holdings = [
        TokenHolding(token: Token.mockTokens[0], amount: 1.2),  // ETH
        TokenHolding(token: Token.mockTokens[1], amount: 0.05), // BTC
        TokenHolding(token: Token.mockTokens[2], amount: 500),  // USDC
        TokenHolding(token: Token.mockTokens[3], amount: 80)   // APT
    ]
    
    // Mock transaction history
    let transactions = [
        Transaction(
            id: UUID(),
            amount: 0.5,
            token: Token.mockTokens[0],
            timestamp: Date().addingTimeInterval(-3600),
            note: "For lunch today",
            chatName: "Alice",
            type: .sent
        ),
        Transaction(
            id: UUID(),
            amount: 100,
            token: Token.mockTokens[2],
            timestamp: Date().addingTimeInterval(-7200),
            note: "Rent payment",
            chatName: nil,
            type: .sent
        ),
        Transaction(
            id: UUID(),
            amount: 0.1,
            token: Token.mockTokens[1],
            timestamp: Date().addingTimeInterval(-86400),
            note: "Coffee money",
            chatName: "Bob",
            type: .received
        )
    ]
    
    @State private var showingPaymentSheet = false
    @State private var showingQRScanner = false
    @State private var selectedTimeFrame = TimeFrame.all
    @State private var searchText = ""
    @State private var isRefreshing = false
    @State private var error: Error?
    @State private var showError = false
    @State private var selectedTab = PaymentTab.holdings
    @State private var isBalanceHidden = false
    
    enum PaymentTab {
        case holdings, transactions
    }
    
    private var totalBalance: Double {
        holdings.reduce(0) { total, holding in
            let price = priceTracker.prices[holding.token.symbol] ?? holding.token.currentPrice
            return total + (holding.amount * price)
        }
    }
    
    private var formattedBalance: String {
        isBalanceHidden ? "****" : String(format: "%.2f", totalBalance)
    }
    
    private var filteredTransactions: [Transaction] {
        var filtered = transactions
        
        // Filter by time frame
        if selectedTimeFrame != .all {
            filtered = filtered.filter { transaction in
                switch selectedTimeFrame {
                case .today:
                    return Calendar.current.isDateInToday(transaction.timestamp)
                case .week:
                    return Calendar.current.isDate(transaction.timestamp, equalTo: Date(), toGranularity: .weekOfYear)
                case .month:
                    return Calendar.current.isDate(transaction.timestamp, equalTo: Date(), toGranularity: .month)
                case .all:
                    return true
                }
            }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.note?.localizedCaseInsensitiveContains(searchText) ?? false ||
                transaction.chatName?.localizedCaseInsensitiveContains(searchText) ?? false ||
                transaction.token.symbol.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                RefreshableView(isRefreshing: $isRefreshing) {
                    await refreshData()
                } content: {
                    VStack(spacing: 24) {
                        // Total Balance Card
                        VStack(spacing: 8) {
                            HStack {
                                Text("Total Balance")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Button(action: { 
                                    withAnimation {
                                        isBalanceHidden.toggle()
                                    }
                                    HapticManager.impact(style: .light)
                                }) {
                                    Image(systemName: isBalanceHidden ? "eye.slash.fill" : "eye.fill")
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            Text("$\(formattedBalance)")
                                .font(.system(size: 34, weight: .bold))
                                .contentTransition(.numericText())
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(uiColor: .systemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.05), radius: 8)
                        
                        // Quick Actions
                        HStack(spacing: 20) {
                            // Send Button
                            Button(action: { showingPaymentSheet = true }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .font(.system(size: 30))
                                    Text("Send")
                                        .font(.callout)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.secondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            // Scan Button
                            Button(action: { showingQRScanner = true }) {
                                VStack(spacing: 8) {
                                    Image(systemName: "qrcode.viewfinder")
                                        .font(.system(size: 30))
                                    Text("Scan")
                                        .font(.callout)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Theme.secondaryBackground)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.horizontal)
                        
                        // Tab Switcher
                        Picker("View", selection: $selectedTab) {
                            Text("Holdings").tag(PaymentTab.holdings)
                            Text("Transactions").tag(PaymentTab.transactions)
                        }
                        .pickerStyle(.segmented)
                        .padding(.horizontal)
                        
                        // Content based on selected tab
                        if selectedTab == .holdings {
                            // Token Holdings Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Your Holdings")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(holdings) { holding in
                                    TokenHoldingRow(holding: holding, isBalanceHidden: $isBalanceHidden)
                                    
                                    if holding.id != holdings.last?.id {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.05), radius: 8)
                        } else {
                            // Transaction History Section
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Transaction History")
                                    .font(.headline)
                                    .padding(.horizontal)
                                
                                ForEach(filteredTransactions) { transaction in
                                    TransactionHistoryRow(transaction: transaction)
                                    
                                    if transaction.id != filteredTransactions.last?.id {
                                        Divider()
                                            .padding(.horizontal)
                                    }
                                }
                            }
                            .padding()
                            .background(Color(uiColor: .systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: .black.opacity(0.05), radius: 8)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Payments")
            .background(Theme.background)
            .sheet(isPresented: $showingPaymentSheet) {
                PaymentSheet()
            }
            .sheet(isPresented: $showingQRScanner) {
                QRScannerView()
            }
            .alert("Error", isPresented: $showError, presenting: error) { _ in
                Button("OK", role: .cancel) {}
                Button("Retry") {
                    Task {
                        await refreshData()
                    }
                }
            } message: { error in
                Text(error.localizedDescription)
            }
        }
    }
    
    private func refreshData() async {
        do {
            // Simulate network request
            try await Task.sleep(nanoseconds: 1_000_000_000)
            // Update data here
            isRefreshing = false
        } catch {
            self.error = error
            showError = true
        }
    }
}

// MARK: - Subviews

struct QuickActionsView: View {
    @Binding var showingPaymentSheet: Bool
    @Binding var showingQRScanner: Bool
    
    var body: some View {
        HStack(spacing: 20) {
            QuickActionButton(
                title: "Send",
                systemName: "arrow.up.circle.fill",
                action: { showingPaymentSheet = true }
            )
            
            QuickActionButton(
                title: "Scan",
                systemName: "qrcode.viewfinder",
                action: { showingQRScanner = true }
            )
        }
    }
}

struct TimeFramePickerView: View {
    @Binding var selectedTimeFrame: TimeFrame
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                    TimeFrameButton(
                        timeFrame: timeFrame,
                        isSelected: timeFrame == selectedTimeFrame,
                        action: { selectedTimeFrame = timeFrame }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
}

struct RecentTransactionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent")
                .font(.headline)
                .padding(.horizontal)
            
            ForEach(0..<5) { i in
                VStack {
                    TransactionRow(
                        name: "User \(i + 1)",
                        amount: Double.random(in: 10...100),
                        token: Token.mockTokens.randomElement()!,
                        timestamp: Date().addingTimeInterval(Double(-i * 3600))
                    )
                    
                    if i < 4 {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct BalanceCard: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Total Balance")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Text("$2,458.35")
                .font(.system(size: 34, weight: .bold))
            
            HStack(spacing: 16) {
                TokenBalance(token: "ETH", amount: "0.85")
                TokenBalance(token: "BTC", amount: "0.023")
                TokenBalance(token: "USDC", amount: "350.00")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.primary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TokenBalance: View {
    let token: String
    let amount: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(token)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(amount)
                .font(.callout)
                .fontWeight(.medium)
        }
    }
}

struct TimeFrameButton: View {
    let timeFrame: TimeFrame
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(timeFrame.rawValue)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Theme.primary : Theme.secondaryBackground)
                .foregroundStyle(isSelected ? .white : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

struct QuickActionButton: View {
    let title: String
    let systemName: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemName)
                    .font(.system(size: 30))
                Text(title)
                    .font(.callout)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Theme.secondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct TransactionRow: View {
    let name: String
    let amount: Double
    let token: Token
    let timestamp: Date
    let note: String? = nil
    
    var body: some View {
        HStack {
            // Avatar
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundStyle(Theme.secondary)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
                if let note = note {
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Text(timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text("\(amount, specifier: "%.2f") \(token.symbol)")
                    .font(.headline)
                Text("$\(amount * token.currentPrice, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color(uiColor: .systemBackground))
    }
}

struct TokenHolding: Identifiable {
    let id = UUID()
    let token: Token
    let amount: Double
}

struct TokenHoldingRow: View {
    let holding: TokenHolding
    @EnvironmentObject private var priceTracker: TokenPriceTracker
    @Binding var isBalanceHidden: Bool
    
    private var tokenPrice: Double {
        priceTracker.prices[holding.token.symbol] ?? holding.token.currentPrice
    }
    
    private var totalValue: Double {
        holding.amount * tokenPrice
    }
    
    var body: some View {
        HStack {
            // Token Icon & Name
            HStack(spacing: 12) {
                Image(systemName: holding.token.iconName)
                    .font(.title2)
                    .foregroundStyle(Theme.primary)
                
                VStack(alignment: .leading) {
                    Text(holding.token.symbol)
                        .font(.headline)
                    Text(holding.token.name)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            // Amount & Value
            VStack(alignment: .trailing) {
                Text(isBalanceHidden ? "****" : "\(holding.amount, specifier: "%.4f")")
                    .font(.headline)
                    .contentTransition(.numericText())
                
                Text(isBalanceHidden ? "****" : "$\(totalValue, specifier: "%.2f")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .contentTransition(.numericText())
            }
        }
        .padding(.vertical, 4)
    }
}

struct Transaction: Identifiable {
    let id: UUID
    let amount: Double
    let token: Token
    let timestamp: Date
    let note: String?
    let chatName: String?
    let type: TransactionType
    
    enum TransactionType {
        case sent, received
    }
}

struct TransactionHistoryRow: View {
    let transaction: Transaction
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                // Transaction Info
                VStack(alignment: .leading, spacing: 4) {
                    if let chatName = transaction.chatName {
                        Text("Chat with \(chatName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    if let note = transaction.note {
                        Text(note)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(transaction.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                // Amount
                VStack(alignment: .trailing) {
                    HStack {
                        Image(systemName: transaction.type == .sent ? "arrow.up" : "arrow.down")
                            .foregroundStyle(transaction.type == .sent ? .red : .green)
                        Text("\(transaction.amount, specifier: "%.4f") \(transaction.token.symbol)")
                            .font(.headline)
                    }
                    
                    Text("$\(transaction.amount * transaction.token.currentPrice, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
} 
