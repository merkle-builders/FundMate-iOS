# FundMate

FundMate is a modern iOS application that combines secure messaging with cryptocurrency payments, allowing users to chat and transfer funds seamlessly in one integrated platform.

## Features

### Authentication
- Secure wallet connection
- Biometric authentication support
- QR code wallet address scanning

### Messaging
- Real-time chat functionality
- Individual and group chat support
- In-chat payment integration
- Message status indicators
- Rich media support (text, payment transactions)

### Payments
- Send/receive cryptocurrency
- Multiple token support (BTC, ETH, USDC, APT)
- Real-time token price tracking
- Transaction history
- QR code payment support
- Detailed payment status tracking

### Profile & Settings
- User profile management
- Wallet address management
- Transaction history
- Security settings
- App preferences

### Notifications
- Payment notifications
- Friend requests
- Real-time updates
- Unread indicators
- Mark all as read functionality

## Technical Architecture

### Models
- `User`: User profile and wallet information
- `Chat`: Chat session and message management
- `Message`: Different types of messages (text, payments)
- `Token`: Cryptocurrency token information
- `Transaction`: Payment transaction details
- `Notification`: System notifications and alerts

### Views
- **Authentication**
  - `WelcomeView`: Initial app entry point
  - `QRScannerView`: QR code scanning interface
  
- **Chat**
  - `HomeView`: Main chat list
  - `ChatDetailView`: Individual chat interface
  - `MessageBubble`: Message display component
  - `PaymentBubble`: Payment transaction display
  
- **Payments**
  - `PaymentsView`: Payment management interface
  - `PaymentSheet`: Payment creation interface
  - `TokenHoldingRow`: Token balance display
  - `TransactionHistoryRow`: Transaction history display
  
- **Profile**
  - `ProfileView`: User profile management
  - `UserProfileView`: User profile display
  
- **Components**
  - `LoadingView`: Loading state indicator
  - `ErrorView`: Error state display
  - `EmptyStateView`: Empty state display
  - `SearchBar`: Search functionality
  - `RefreshableView`: Pull-to-refresh functionality

### Utilities
- `TokenPriceTracker`: Real-time cryptocurrency price tracking
- `HapticManager`: Haptic feedback management
- `CameraManager`: Camera access for QR scanning
- `BiometricAuthManager`: Biometric authentication
- `Theme`: App-wide styling and theming

## Design System

### Colors
- Primary: Main brand color
- Secondary: Supporting color
- Background: View backgrounds
- SecondaryBackground: Alternative backgrounds
- Text: Primary text color
- SecondaryText: Supporting text color
- Positive/Negative: Status indicators

### Typography
- Headlines: `.headline`
- Body Text: `.body`
- Captions: `.caption`
- Subheadlines: `.subheadline`

### Components
- Buttons: Bordered and filled styles
- Cards: Rounded corners with subtle shadows
- Lists: Clean, minimal styling
- Navigation: Standard iOS navigation patterns

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/FundMate.git
```

2. Open the project in Xcode
```bash
cd FundMate
open FundMate.xcodeproj
```

3. Build and run the project

### Configuration
- Update the token price tracking API keys in `TokenPriceTracker`
- Configure the wallet connection settings
- Set up your development team in Xcode

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

- SwiftUI for the modern UI framework
- Apple for iOS development tools
- The cryptocurrency community for inspiration
