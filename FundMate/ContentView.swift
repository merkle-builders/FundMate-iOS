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
    @State private var showingProfile = false
    let chats = Chat.mockChats
    @Binding var isAuthenticated: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText, placeholder: "Search chats")
                    .padding()
                
                // Chat list
                List(chats) { chat in
                    ChatRow(chat: chat)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Chats")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showingProfile = true
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title2)
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
            .sheet(isPresented: $showingProfile) {
                ProfileView(isAuthenticated: $isAuthenticated)
            }
        }
    }
}

struct ChatRow: View {
    let chat: Chat
    @State private var showingProfile = false
    
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
                        if chat.user != nil {
                            Button(action: { showingProfile = true }) {
                                Text(chat.name)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                            }
                        } else {
                            Text(chat.name)
                                .font(.headline)
                        }
                        
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
        .sheet(isPresented: $showingProfile) {
            if let user = chat.user {
                UserProfileView(user: user, isCurrentUser: false)
            }
        }
    }
}

#Preview {
    ContentView()
}
