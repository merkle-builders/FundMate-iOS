import SwiftUI

struct ChatDetailView: View {
    let chat: Chat
    @State private var messageText = ""
    @State private var messages: [Message] = Message.mockMessages
    @State private var showingPaymentSheet = false
    @State private var scrollProxy: ScrollViewProxy?
    @State private var showScrollToBottom = false
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages) { _ in
                    withAnimation {
                        proxy.scrollTo(messages.last?.id, anchor: .bottom)
                    }
                }
                .onAppear {
                    scrollProxy = proxy
                }
            }
            
            MessageInputBar(
                text: $messageText,
                onSend: sendMessage,
                onPaymentTap: { showingPaymentSheet = true }
            )
        }
        .overlay(alignment: .bottomTrailing) {
            if showScrollToBottom {
                Button(action: scrollToBottom) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title)
                        .foregroundStyle(Theme.primary)
                        .background(.background)
                        .clipShape(Circle())
                }
                .padding()
                .transition(.scale.combined(with: .opacity))
            }
        }
        .navigationTitle(chat.name)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingPaymentSheet) {
            PaymentSheet()
        }
    }
    
    private func sendMessage() {
        guard !messageText.isEmpty else { return }
        
        let newMessage = Message(
            id: UUID(),
            content: messageText,
            timestamp: Date(),
            isFromCurrentUser: true,
            type: .text
        )
        
        withAnimation {
            messages.append(newMessage)
        }
        
        messageText = ""
        HapticManager.notification(type: .success)
    }
    
    private func scrollToBottom() {
        withAnimation {
            scrollProxy?.scrollTo(messages.last?.id, anchor: .bottom)
        }
    }
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser { Spacer() }
            
            VStack(alignment: message.isFromCurrentUser ? .trailing : .leading) {
                switch message.type {
                case .text:
                    Text(message.content)
                        .padding(12)
                        .background(message.isFromCurrentUser ? Theme.primary : Theme.secondaryBackground)
                        .foregroundStyle(message.isFromCurrentUser ? .white : Theme.text)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                case .payment(let amount, let status, let note):
                    PaymentBubble(amount: amount, status: status, note: note)
                }
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            
            if !message.isFromCurrentUser { Spacer() }
        }
    }
}

struct PaymentBubble: View {
    let amount: Double
    let status: Message.PaymentStatus
    let note: String?
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: statusIcon)
                .font(.title2)
            
            Text("$\(amount, specifier: "%.2f")")
                .font(.headline)
            
            if let note = note {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            Text(statusText)
                .font(.caption)
        }
        .padding()
        .frame(width: 140)
        .background(Theme.secondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private var statusIcon: String {
        switch status {
        case .completed: return "checkmark.circle.fill"
        case .pending: return "clock.fill"
        case .failed: return "exclamationmark.circle.fill"
        }
    }
    
    private var statusText: String {
        switch status {
        case .completed: return "Sent"
        case .pending: return "Pending"
        case .failed: return "Failed"
        }
    }
}

struct MessageInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    let onPaymentTap: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Payment button
            Button(action: onPaymentTap) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.title2)
                    .foregroundStyle(Theme.primary)
            }
            
            // Text field
            TextField("Message", text: $text)
                .padding(8)
                .background(Theme.secondaryBackground)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            
            // Send button
            Button(action: onSend) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
                    .foregroundStyle(text.isEmpty ? Theme.secondary : Theme.primary)
            }
            .disabled(text.isEmpty)
        }
        .padding()
        .background(.bar)
    }
} 