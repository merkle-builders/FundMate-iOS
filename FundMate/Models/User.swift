import Foundation

struct User: Codable {
    var username: String?
    var walletAddress: String
    var avatarSystemName: String
    
    var displayName: String {
        username ?? walletAddress.prefix(6) + "..." + walletAddress.suffix(4)
    }
    
    static let mockUser = User(
        username: nil,
        walletAddress: "0x1234567890abcdef1234567890abcdef12345678",
        avatarSystemName: "person.circle.fill"
    )
} 