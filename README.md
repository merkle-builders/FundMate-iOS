# FundMate

FundMate is a modern iOS application that combines secure messaging with cryptocurrency payments, allowing users to chat and transfer funds seamlessly in one integrated platform.

## Features

### Authentication
- Secure wallet connection
- QR code wallet address scanning

### Messaging
- Real-time chat functionality
- Individual chat support
- In-chat payment integration
- Message status indicators
- Rich media support (text, payment transactions)

### Payments
- Send/receive cryptocurrency
- Multiple token support (APT)
- Transaction history
- QR code payment support
- Payment status tracking

### Profile & Settings
- User profile management
- Wallet address management
- Transaction history

## Technical Architecture

### Models
- `User`: User profile and wallet information
- `Chat`: Chat session and message management
- `Message`: Different types of messages (text, payments)
- `Transaction`: Payment transaction details

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
  - `TransactionHistoryRow`: Transaction history display
  
- **Profile**
  - `ProfileView`: User profile management
  
- **Components**
  - `LoadingView`: Loading state indicator
  - `ErrorView`: Error state display
  - `EmptyStateView`: Empty state display

### Utilities
- `CameraManager`: Camera access for QR scanning
- `Theme`: App-wide styling and theming

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Installation
1. Clone the repository
```bash
git clone https://github.com/yourusername/FundMate
```

2. Open the project in Xcode
```bash
cd FundMate
open FundMate.xcodeproj
```

3. Build and run the project

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/YourFeature`)
3. Commit your changes (`git commit -m 'Add some feature'`)
4. Push to the branch (`git push origin feature/YourFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
