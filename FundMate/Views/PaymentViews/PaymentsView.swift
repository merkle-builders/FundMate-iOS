import SwiftUI

enum TimeFrame: String, CaseIterable {
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    case all = "All"
}

struct PaymentsView: View {
    @State private var showingPaymentSheet = false
    @State private var showingQRScanner = false
    @State private var selectedTimeFrame = TimeFrame.all
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    // Balance Card
                    BalanceCard()
                        .padding(.horizontal)
                    
                    // Quick Actions
                    QuickActionsView(
                        showingPaymentSheet: $showingPaymentSheet,
                        showingQRScanner: $showingQRScanner
                    )
                    .padding(.horizontal)
                    
                    // Time Frame Picker
                    TimeFramePickerView(selectedTimeFrame: $selectedTimeFrame)
                    
                    // Search Bar
                    SearchBar(text: $searchText, placeholder: "Search transactions")
                        .padding(.horizontal)
                    
                    // Recent Transactions
                    RecentTransactionsView()
                }
            }
            .navigationTitle("Payments")
            .sheet(isPresented: $showingPaymentSheet) {
                PaymentSheet()
            }
            .sheet(isPresented: $showingQRScanner) {
                QRScannerView()
            }
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
    
    var body: some View {
        HStack {
            // Avatar
            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundStyle(Theme.secondary)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.headline)
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