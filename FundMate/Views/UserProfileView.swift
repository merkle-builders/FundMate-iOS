import SwiftUI

struct UserProfileView: View {
    let user: User
    let isCurrentUser: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var showingQRCode = false
    @State private var showingPaymentSheet = false
    
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
                        }
                        .padding(.horizontal)
                    }
                    
                    // Transaction History
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent Transactions")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(0..<3) { i in
                            TransactionRow(
                                name: isCurrentUser ? "User \(i + 1)" : user.displayName,
                                amount: Double.random(in: 10...100),
                                token: Token.mockTokens.randomElement()!,
                                timestamp: Date().addingTimeInterval(Double(-i * 86400))
                            )
                            
                            if i < 2 {
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
} 