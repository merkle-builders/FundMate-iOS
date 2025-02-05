import Foundation

struct Chat: Identifiable {
    let id: UUID
    let name: String
    let lastMessage: String
    let timestamp: Date
    let avatarSystemName: String // Using SF Symbols for now
    let user: User? // Add this property for individual chats
    
    static let mockChats = [
        Chat(
            id: UUID(),
            name: "Alice",
            lastMessage: "Sure, I'll send the payment!",
            timestamp: Date().addingTimeInterval(-300),
            avatarSystemName: "person.circle.fill",
            user: User(
                username: "Alice",
                walletAddress: "0x1234567890abcdef1234567890abcdef12345678",
                avatarSystemName: "person.circle.fill"
            )
        ),
        Chat(
            id: UUID(),
            name: "Bob",
            lastMessage: "Thanks for lunch!",
            timestamp: Date().addingTimeInterval(-3600),
            avatarSystemName: "person.circle.fill",
            user: User(
                username: "Bob",
                walletAddress: "0x2345678901abcdef2345678901abcdef23456789",
                avatarSystemName: "person.circle.fill"
            )
        ),
        Chat(
            id: UUID(),
            name: "Crypto Group",
            lastMessage: "Did you see the new update?",
            timestamp: Date().addingTimeInterval(-7200),
            avatarSystemName: "person.3.fill",
            user: nil  // Group chats don't have a single user
        ),
        Chat(
            id: UUID(),
            name: "David",
            lastMessage: "Let's split the bill",
            timestamp: Date().addingTimeInterval(-86400),
            avatarSystemName: "person.circle.fill",
            user: User(
                username: "David",
                walletAddress: "0x3456789012abcdef3456789012abcdef34567890",
                avatarSystemName: "person.circle.fill"
            )
        )
    ]
} 