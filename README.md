# FundMate - Chat & Pay iOS App

FundMate is a modern iOS application that combines messaging and cryptocurrency payments, allowing users to chat and send payments seamlessly in one integrated experience.

## 🌟 Features

### 💬 Messaging
- Real-time one-on-one and group chats
- Message search functionality
- Read receipts and typing indicators
- Swipe to reply and message reactions

### 💰 Payments
- Send and receive cryptocurrency payments
- Multi-token support (ETH, BTC, USDC, APT)
- Real-time token conversion
- QR code payment scanning
- Transaction history tracking

### 👤 Profile & Settings
- Customizable usernames
- Personal QR code for receiving payments
- Dark mode support
- Wallet management
- Transaction history

### 🔐 Security
- Secure wallet connection
- Transaction authentication
- Privacy settings

## 🛠 Technical Stack

- **Framework:** SwiftUI
- **Architecture:** MVVM
- **Dependencies:** 
  - CoreImage (QR Code generation)
  - AVFoundation (QR scanning)
  - Combine (State management)

## 📱 Screenshots
![Simulator Screenshot - iPhone 16 Pro - 2025-02-05 at 12 19 08](https://github.com/user-attachments/assets/4945fefb-da38-487c-ba81-7832bd28ec1c)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-05 at 12 20 04](https://github.com/user-attachments/assets/f3995479-a540-499f-8cb3-9bb1a0412eac)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-05 at 12 20 11](https://github.com/user-attachments/assets/abebda92-edd7-49b5-918a-79d814b51536)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-05 at 12 20 47](https://github.com/user-attachments/assets/900be893-5098-4a2c-b598-bdacf212ba2d)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-05 at 12 20 24](https://github.com/user-attachments/assets/d732bcf2-eab7-4290-88ac-c89a4c43c771)
![Simulator Screenshot - iPhone 16 Pro - 2025-02-05 at 12 20 34](https://github.com/user-attachments/assets/a1050309-49d4-4ef2-902f-54ff07009b5a)


## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- macOS Ventura or later

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



3. Build and run the project in Xcode

## 📋 Project Structure
FundMate/
├── Models/
│ ├── Chat.swift
│ ├── Message.swift
│ ├── Token.swift
│ └── User.swift
├── Views/
│ ├── Components/
│ │ └── SearchBar.swift
│ ├── PaymentViews/
│ │ ├── PaymentSheet.swift
│ │ └── PaymentsView.swift
│ ├── ChatDetailView.swift
│ ├── ProfileView.swift
│ └── QRScannerView.swift
├── Utilities/
│ ├── CameraManager.swift
│ ├── HapticManager.swift
│ └── QRGenerator.swift
└── Resources/
└── Theme.swift

## 🎯 Future Enhancements

- [ ] Push notifications
- [ ] File sharing in chats
- [ ] Voice messages
- [ ] Multi-language support
- [ ] Advanced payment features
  - [ ] Payment scheduling
  - [ ] Recurring payments
  - [ ] Split bills
- [ ] Blockchain integration
  - [ ] Smart contract support
  - [ ] Multiple chain support

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## 👥 Authors

- Mihir Sahu - *Initial work* - [Github](https://github.com/0xmihirsahu)

## 🙏 Acknowledgments

- SwiftUI community
- Cryptocurrency payment integration resources
- UI/UX design inspiration sources
