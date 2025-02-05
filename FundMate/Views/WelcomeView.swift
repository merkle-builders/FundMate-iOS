import SwiftUI

struct WelcomeView: View {
    @Binding var isAuthenticated: Bool
    @State private var isLoading = false
    @State private var error: Error?
    @State private var showError = false
    @State private var animateBackground = false
    @State private var showContent = false
    @State private var showSuccess = false
    
    var body: some View {
        ZStack {
            // Animated background
            GeometryReader { proxy in
                ZStack {
                    Circle()
                        .fill(Theme.primary.opacity(0.3))
                        .frame(width: proxy.size.width * 0.8)
                        .offset(x: -proxy.size.width * 0.2, y: -proxy.size.height * 0.2)
                        .blur(radius: 50)
                    
                    Circle()
                        .fill(Theme.secondary.opacity(0.2))
                        .frame(width: proxy.size.width * 0.7)
                        .offset(x: proxy.size.width * 0.3, y: proxy.size.height * 0.3)
                        .blur(radius: 50)
                }
                .scaleEffect(animateBackground ? 1.2 : 1.0)
            }
            .ignoresSafeArea()
            
            // Content
            VStack(spacing: 24) {
                // Logo and App Name
                VStack(spacing: 16) {
                    Image(systemName: "message.and.waveform.fill")
                        .font(.system(size: 80))
                        .foregroundStyle(.tint)
                        .modifier(LogoBounceModifier())
                        .shadow(color: Theme.primary.opacity(0.3), radius: 10, y: 5)
                    
                    Text("FundMate")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(Theme.primary)
                }
                .modifier(SlideTransitionModifier(edge: .top))
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                // Welcome Message
                VStack(spacing: 8) {
                    Text("Welcome to FundMate")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("Chat and send payments seamlessly")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                
                Spacer()
                
                // Connect Wallet Button or Success State
                if isLoading {
                    LoadingView(text: "Connecting wallet...")
                        .transition(.scale.combined(with: .opacity))
                } else if showSuccess {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 60))
                            .foregroundStyle(.green)
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("Wallet Connected!")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                    }
                    .transition(.scale.combined(with: .opacity))
                } else {
                    Button(action: connectWallet) {
                        HStack {
                            Image(systemName: "wallet.pass.fill")
                            Text("Connect Wallet")
                                .font(.headline)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Theme.primary)
                                .shadow(color: Theme.primary.opacity(0.3), radius: 10, y: 5)
                        )
                    }
                    .opacity(showContent ? 1 : 0)
                    .offset(y: showContent ? 0 : 20)
                }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: true)) {
                animateBackground = true
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                showContent = true
            }
        }
        .alert("Connection Error", isPresented: $showError, presenting: error) { _ in
            Button("OK", role: .cancel) {}
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private func connectWallet() {
        withAnimation {
            isLoading = true
        }
        
        // Simulate wallet connection with success animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                isLoading = false
                showSuccess = true
            }
            HapticManager.notification(type: .success)
            
            // Wait a moment to show success state before transitioning
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    isAuthenticated = true
                }
            }
        }
    }
} 