//
//  ContentView.swift
//  FundMate
//
//  Created by Mihir Sahu on 5/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var selectedTab = Tab.chats
    @State private var previousTab = Tab.chats
    
    enum Tab {
        case chats, payments, scan, settings
        
        var index: Int {
            switch self {
            case .chats: return 0
            case .payments: return 1
            case .scan: return 2
            case .settings: return 3
            }
        }
    }
    
    var body: some View {
        if isAuthenticated {
            TabView(selection: $selectedTab) {
                HomeView(isAuthenticated: $isAuthenticated)
                    .tabItem {
                        Label("Chats", systemImage: "bubble.left.and.bubble.right")
                    }
                    .tag(Tab.chats)
                    .tabTransition(direction: Double(Tab.chats.index - previousTab.index))
                
                PaymentsView()
                    .tabItem {
                        Label("Payments", systemImage: "dollarsign.circle")
                    }
                    .tag(Tab.payments)
                    .tabTransition(direction: Double(Tab.payments.index - previousTab.index))
                
                QRScannerView()
                    .tabItem {
                        Label("Scan", systemImage: "qrcode.viewfinder")
                    }
                    .tag(Tab.scan)
                    .tabTransition(direction: Double(Tab.scan.index - previousTab.index))
                
                ProfileView(isAuthenticated: $isAuthenticated)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
                    .tabTransition(direction: Double(Tab.settings.index - previousTab.index))
            }
            .tint(Theme.primary)
            .onChange(of: selectedTab) { oldTab, newTab in
                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                    previousTab = oldTab
                    selectedTab = newTab
                }
            }
        } else {
            WelcomeView(isAuthenticated: $isAuthenticated)
        }
    }
}

struct WelcomeView: View {
    @Binding var isAuthenticated: Bool
    @State private var isLoading = false
    @State private var error: Error?
    @State private var showError = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Logo and App Name
            VStack(spacing: 16) {
                Image(systemName: "message.and.waveform.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.tint)
                    .symbolEffect(.bounce, options: .repeating)
                
                Text("FundMate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .slideTransition(.top)
            
            // Welcome Message
            VStack(spacing: 8) {
                Text("Welcome to FundMate")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("Chat and send payments seamlessly")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .slideTransition(.trailing)
            
            Spacer()
            
            // Connect Wallet Button
            if isLoading {
                LoadingView(text: "Connecting wallet...")
            } else {
                Button(action: connectWallet) {
                    Text("Connect Wallet")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .slideTransition(.bottom)
            }
        }
        .padding()
        .alert("Connection Error", isPresented: $showError, presenting: error) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private func connectWallet() {
        isLoading = true
        
        // Simulate wallet connection with guaranteed success
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            withAnimation {
                isAuthenticated = true
            }
            HapticManager.notification(type: .success)
        }
    }
}

struct HomeView: View {
    @State private var searchText = ""
    @State private var showingNotifications = false
    @State private var notifications: [Notification] = [
        Notification(
            id: UUID(),
            type: .friendRequest,
            user: User(
                username: nil,
                walletAddress: "0x456789abcdef456789abcdef456789abcdef4567",
                avatarSystemName: "person.circle.fill"
            ),
            timestamp: Date(),
            isRead: false
        ),
        Notification(
            id: UUID(),
            type: .payment(amount: 50.0, status: .completed),
            user: User(
                username: "Bob",
                walletAddress: "0x789abcdef0123456789abcdef0123456789abcd",
                avatarSystemName: "person.circle.fill"
            ),
            timestamp: Date().addingTimeInterval(-3600),
            isRead: false
        )
    ]
    let chats = Chat.mockChats
    @Binding var isAuthenticated: Bool
    
    private var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                SearchBar(text: $searchText, placeholder: "Search chats")
                    .padding()
                
                List(chats) { chat in
                    ChatRow(chat: chat)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showingNotifications = true }) {
                        Image(systemName: unreadCount > 0 ? "bell.badge.fill" : "bell.fill")
                            .font(.title2)
                            .overlay(alignment: .topTrailing) {
                                if unreadCount > 0 {
                                    Text("\(unreadCount)")
                                        .font(.caption2)
                                        .padding(4)
                                        .background(.red)
                                        .foregroundStyle(.white)
                                        .clipShape(Circle())
                                        .offset(x: 4, y: -4)
                                }
                            }
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        // TODO: Start new chat
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingNotifications) {
                NotificationsView(notifications: $notifications)
            }
        }
    }
}

struct ChatRow: View {
    let chat: Chat
    
    var body: some View {
        NavigationLink(destination: ChatDetailView(chat: chat)) {
            HStack(spacing: 12) {
                // Avatar
                Group {
                    if chat.name.contains("Group") {
                        Image(systemName: chat.avatarSystemName)
                            .font(.system(size: 32))
                            .foregroundStyle(Theme.primary)
                            .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: chat.avatarSystemName)
                            .font(.system(size: 40))
                            .foregroundStyle(Theme.primary)
                    }
                }
                
                // Chat info
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(chat.name)
                            .font(.headline)
                        
                        Spacer()
                        
                        Text(chat.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    
                    Text(chat.lastMessage)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(.vertical, 8)
        }
    }
}

// Add these new types
struct Notification: Identifiable {
    let id: UUID
    let type: NotificationType
    let user: User
    let timestamp: Date
    var isRead: Bool
    
    enum NotificationType {
        case friendRequest
        case payment(amount: Double, status: Message.PaymentStatus)
    }
}

struct NotificationsView: View {
    @Binding var notifications: [Notification]
    @Environment(\.dismiss) private var dismiss
    
    private var unreadCount: Int {
        notifications.filter { !$0.isRead }.count
    }
    
    var body: some View {
        NavigationStack {
            List(notifications) { notification in
                NotificationRow(notification: notification)
                    .listRowBackground(notification.isRead ? nil : Theme.secondaryBackground)
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if unreadCount > 0 {
                        Button("Mark All as Read") {
                            markAllAsRead()
                        }
                        .font(.subheadline)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func markAllAsRead() {
        withAnimation {
            for index in notifications.indices {
                notifications[index].isRead = true
            }
        }
        HapticManager.notification(type: .success)
    }
}

struct NotificationRow: View {
    let notification: Notification
    
    private var userDisplayName: String {
        notification.user.username ?? String(notification.user.walletAddress.prefix(6) + "..." + notification.user.walletAddress.suffix(4))
    }
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: notification.user.avatarSystemName)
                .font(.title2)
                .foregroundStyle(Theme.primary)
            
            VStack(alignment: .leading, spacing: 4) {
                switch notification.type {
                case .friendRequest:
                    Text("\(userDisplayName) sent you a friend request")
                        .font(.subheadline)
                    
                    Text(notification.user.walletAddress)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    HStack {
                        Button("Accept") {
                            // Handle accept
                            HapticManager.notification(type: .success)
                        }
                        .buttonStyle(.bordered)
                        
                        Button("Decline", role: .destructive) {
                            // Handle decline
                            HapticManager.notification(type: .error)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                case .payment(let amount, let status):
                    Text("\(userDisplayName) sent you $\(amount, specifier: "%.2f")")
                        .font(.subheadline)
                    
                    Text(notification.user.walletAddress)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text(status.rawValue)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Text(notification.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
}
