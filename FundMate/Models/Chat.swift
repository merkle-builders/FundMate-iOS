import Foundation

struct Chat: Identifiable {
    let id: UUID
    let name: String
    let lastMessage: String
    let timestamp: Date
    let avatarSystemName: String // Using SF Symbols for now
    
    static let mockChats = [
        Chat(id: UUID(), name: "Alice", lastMessage: "Sure, I'll send the payment!", timestamp: Date().addingTimeInterval(-300), avatarSystemName: "person.circle.fill"),
        Chat(id: UUID(), name: "Bob", lastMessage: "Thanks for lunch!", timestamp: Date().addingTimeInterval(-3600), avatarSystemName: "person.circle.fill"),
        Chat(id: UUID(), name: "Crypto Group", lastMessage: "Did you see the new update?", timestamp: Date().addingTimeInterval(-7200), avatarSystemName: "person.3.fill"),
        Chat(id: UUID(), name: "David", lastMessage: "Let's split the bill", timestamp: Date().addingTimeInterval(-86400), avatarSystemName: "person.circle.fill")
    ]
} 