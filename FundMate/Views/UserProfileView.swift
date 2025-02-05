import SwiftUI

struct UserProfileView: View {
    let user: User
    let isCurrentUser: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showingQRCode = false
    @State private var showingPaymentSheet = false
    @State private var isFriend = false  // In real app, this would come from a backend
    
    // Mock transactions for profile
    private let transactions = [
        Transaction(
            id: UUID(),
            amount: 20,
            token: Token.mockTokens[0],
            timestamp: Date().addingTimeInterval(-3600),
            note: "Lunch",
            chatName: nil,
            type: .sent
        ),
        Transaction(
            id: UUID(),
            amount: 50,
            token: Token.mockTokens[2],
            timestamp: Date().addingTimeInterval(-86400),
            note: "Movie tickets",
            chatName: nil,
            type: .received
        )
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        Image(systemName: user.avatarSystemName)
                            .font(.system(size: 80))
                            .foregroundStyle(Theme.primary)
                        
                        VStack(spacing: 4) {
                            Text(user.displayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.walletAddress)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    
                    if !isCurrentUser {
                        // Action Buttons
                        HStack(spacing: 20) {
                            // Send Payment Button
                            Button(action: { showingPaymentSheet = true }) {
                                VStack {
                                    Image(systemName: "dollarsign.circle.fill")
                                        .font(.title)
                                    Text("Send")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .tint(Theme.primary)
                            
                            // QR Code Button
                            Button(action: { showingQRCode = true }) {
                                VStack {
                                    Image(systemName: "qrcode")
                                        .font(.title)
                                    Text("QR Code")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .tint(Theme.primary)
                            
                            // Add Friend Button
                            Button(action: toggleFriend) {
                                VStack {
                                    Image(systemName: isFriend ? "person.badge.minus" : "person.badge.plus")
                                        .font(.title)
                                    Text(isFriend ? "Remove" : "Add Friend")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .tint(isFriend ? .red : Theme.primary)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Transaction History
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Transactions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(transactions) { transaction in
                            TransactionHistoryRow(transaction: transaction)
                            
                            if transaction.id != transactions.last?.id {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle(isCurrentUser ? "My Profile" : "Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                if !isCurrentUser {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button(role: .destructive) {
                                // Block user action
                            } label: {
                                Label("Block User", systemImage: "slash.circle")
                            }
                            
                            Button(role: .destructive) {
                                // Report user action
                            } label: {
                                Label("Report User", systemImage: "exclamationmark.triangle")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
            .sheet(isPresented: $showingQRCode) {
                QRCodeView(user: user)
            }
            .sheet(isPresented: $showingPaymentSheet) {
                PaymentSheet(receiverAddress: user.walletAddress)
            }
        }
    }
    
    private func toggleFriend() {
        withAnimation {
            isFriend.toggle()
        }
        HapticManager.notification(type: isFriend ? .success : .warning)
    }
} 