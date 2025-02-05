import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var user = User.mockUser
    @State private var showingEditProfile = false
    @State private var showingQRCode = false
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationStack {
            List {
                // Profile Section
                Section {
                    HStack(spacing: 16) {
                        Image(systemName: user.avatarSystemName)
                            .font(.system(size: 60))
                            .foregroundStyle(Theme.primary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.displayName)
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text(user.walletAddress)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                    
                    Button(action: { showingQRCode = true }) {
                        Label("Show QR Code", systemImage: "qrcode")
                    }
                }
                
                // Preferences Section
                Section("Preferences") {
                    Toggle("Dark Mode", isOn: $isDarkMode)
                    
                    Button("Edit Profile") {
                        showingEditProfile = true
                    }
                }
                
                // Wallet Section
                Section("Wallet") {
                    NavigationLink("Transaction History") {
                        TransactionHistoryView()
                    }
                    
                    NavigationLink("Wallet Settings") {
                        WalletSettingsView()
                    }
                }
                
                // Support Section
                Section("Support") {
                    NavigationLink("Help Center") {
                        HelpCenterView()
                    }
                    
                    Link("Privacy Policy", destination: URL(string: "https://fundmate.privacy")!)
                    
                    Link("Terms of Service", destination: URL(string: "https://fundmate.terms")!)
                }
                
                // Logout Section
                Section {
                    Button(role: .destructive) {
                        isAuthenticated = false
                    } label: {
                        Text("Disconnect Wallet")
                    }
                }
            }
            .navigationTitle("Profile")
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: $user)
            }
            .sheet(isPresented: $showingQRCode) {
                QRCodeView(user: user)
            }
        }
    }
}

struct QRCodeView: View {
    @Environment(\.dismiss) private var dismiss
    let user: User
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Profile Info
                VStack(spacing: 8) {
                    Image(systemName: user.avatarSystemName)
                        .font(.system(size: 60))
                        .foregroundStyle(Theme.primary)
                    
                    Text(user.displayName)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                // QR Code
                Image(uiImage: QRGenerator.generateQRCode(from: user.walletAddress))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Wallet Address
                VStack(spacing: 8) {
                    Text("Wallet Address")
                        .font(.headline)
                    
                    Text(user.walletAddress)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                // Copy Button
                Button(action: {
                    UIPasteboard.general.string = user.walletAddress
                    HapticManager.notification(type: .success)
                }) {
                    Label("Copy Address", systemImage: "doc.on.doc")
                        .padding()
                        .background(Theme.secondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
            .navigationTitle("My QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    ShareLink(item: user.walletAddress) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var user: User
    @State private var username = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Profile Information") {
                    TextField("Username", text: $username)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    Text("This username will be visible to other users")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Section {
                    Button("Save Changes") {
                        validateAndSave()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                username = user.username ?? ""
            }
            .alert("Invalid Username", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Username must be between 3 and 20 characters and can only contain letters, numbers, and underscores.")
            }
        }
    }
    
    private func validateAndSave() {
        let usernamePattern = "^[a-zA-Z0-9_]{3,20}$"
        if username.isEmpty {
            user.username = nil
            dismiss()
        } else if username.range(of: usernamePattern, options: .regularExpression) != nil {
            user.username = username
            dismiss()
        } else {
            showingError = true
        }
    }
}

// Placeholder views for navigation
struct TransactionHistoryView: View {
    var body: some View {
        List {
            ForEach(0..<5) { i in
                VStack(alignment: .leading) {
                    Text("Transaction \(i + 1)")
                        .font(.headline)
                    Text("0.01 ETH")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Transaction History")
    }
}

struct WalletSettingsView: View {
    var body: some View {
        List {
            Section("Network") {
                Text("Ethereum Mainnet")
            }
            Section("Security") {
                Toggle("Require Authentication", isOn: .constant(true))
                Toggle("Transaction Notifications", isOn: .constant(true))
            }
        }
        .navigationTitle("Wallet Settings")
    }
}

struct HelpCenterView: View {
    var body: some View {
        List {
            Section("FAQs") {
                Text("How to send payments?")
                Text("How to connect wallet?")
                Text("Security tips")
            }
            Section("Contact Support") {
                Button("Email Support") {}
                Button("Chat with Us") {}
            }
        }
        .navigationTitle("Help Center")
    }
} 