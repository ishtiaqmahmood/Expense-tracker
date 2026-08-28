# 💰 Pro Expense Tracker - Professional Finance Management

[![Flutter](https://img.shields.io/badge/Flutter-3.13+-blue.svg)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-green.svg)](https://flutter.dev)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/version-2.0.0-orange.svg)]()
[![Play Store Ready](https://img.shields.io/badge/Play%20Store-Ready-brightgreen.svg)]()

## 📱 Overview

**Pro Expense Tracker** is a premium, feature-rich Flutter application designed for professional expense management with enterprise-grade security, beautiful analytics, and seamless data export capabilities. Built with Material Design 3 principles and optimized for Android devices of all screen sizes.

---

## ✨ Key Features

### 🔒 **Enterprise-Grade Security**
- ✅ Biometric Authentication (Fingerprint/Face ID)
- ✅ PIN Code Protection with Encryption
- ✅ Secure Local Storage with AES-256 Encryption
- ✅ Auto-Lock on App Minimize
- ✅ Private Mode for Sensitive Transactions

### 📊 **Advanced Analytics & Charts**
- ✅ Interactive Pie Charts (Syncfusion & FL Chart)
- ✅ Beautiful Bar Charts with Animations
- ✅ 7-Day Spending Overview
- ✅ Monthly/Yearly Comparison
- ✅ Category-wise Breakdown
- ✅ Income vs Expense Trends
- ✅ Budget Progress Tracking

### 📤 **Data Export & Sharing**
- ✅ Professional PDF Reports with Custom Branding
- ✅ Excel (.xlsx) Export
- ✅ CSV Export for Spreadsheet Compatibility
- ✅ Share via Any Installed App
- ✅ Print-Ready PDF Format
- ✅ Backup & Restore (JSON Format)

### 💾 **Local Storage & Data Persistence**
- ✅ Isar NoSQL Database (Lightning Fast)
- ✅ Hive Secondary Storage
- ✅ SharedPreferences for Settings
- ✅ Automatic Data Sync
- ✅ Offline-First Architecture

### 📜 **Transaction History Management**
- ✅ Complete Transaction History
- ✅ Advanced Filtering (Date, Category, Type)
- ✅ Search Functionality
- ✅ Swipe-to-Delete with Confirmation
- ✅ Bulk Delete Operations
- ✅ Edit Existing Transactions
- ✅ Recurring Transactions Support

### 🎨 **Beautiful UI/UX**
- ✅ Material Design 3 Components
- ✅ Dark/Light Theme Support
- ✅ Smooth Animations (Flutter Animate)
- ✅ Lottie Animations
- ✅ Shimmer Loading Effects
- ✅ Responsive Layout for All Screen Sizes
- ✅ Custom Color Schemes per Category

### 🌍 **Multi-Language & Currency**
- ✅ 7+ Languages Supported (EN, ES, FR, DE, ZH, JA, HI)
- ✅ 18+ Currencies with Real-time Symbols
- ✅ Locale-Aware Date Formatting
- ✅ RTL Support Ready

### 🔔 **Smart Notifications**
- ✅ Daily Expense Reminders
- ✅ Budget Limit Alerts
- ✅ Bill Payment Reminders
- ✅ Weekly/Monthly Reports
- ✅ Customizable Notification Settings

### 📅 **Calendar Integration**
- ✅ Table Calendar View
- ✅ Date-based Transaction Visualization
- ✅ Quick Add from Calendar
- ✅ Monthly Spending Heatmap

### 🎯 **Budget Management**
- ✅ Set Budget Limits per Category
- ✅ Visual Progress Indicators
- ✅ Overspending Alerts
- ✅ Multiple Budget Periods (Daily/Weekly/Monthly/Yearly)

### 📸 **Receipt Management**
- ✅ Capture Receipt Photos
- ✅ Image Cropping & Enhancement
- ✅ Attach Receipts to Transactions
- ✅ Gallery View of Receipts

### ⭐ **Play Store Ready Features**
- ✅ In-App Review Integration
- ✅ Device Information Handling
- ✅ Connectivity Status Check
- ✅ Proper App Lifecycle Management
- ✅ Android Manifest Optimized
- ✅ Adaptive Icons Support
- ✅ Privacy Policy Ready

---

## 🏗️ Architecture

```
lib/
├── main.dart                 # App entry point with initialization
├── models/                   # Data models
│   ├── expense.dart          # Expense model with Isar annotations
│   ├── budget.dart           # Budget tracking model
│   └── settings.dart         # App settings model
├── providers/                # State management (Provider)
│   ├── theme_provider.dart   # Theme management
│   ├── settings_provider.dart # Settings & preferences
│   ├── expense_provider.dart # Expense operations
│   └── auth_provider.dart    # Authentication state
├── screens/                  # App screens
│   ├── splash_screen.dart    # Animated splash
│   ├── auth_screen.dart      # Login/PIN/Biometric
│   ├── home_screen.dart      # Main dashboard
│   └── settings_screen.dart  # App settings
├── services/                 # Business logic
│   ├── database_service.dart # Isar database operations
│   ├── auth_service.dart     # Biometric & PIN auth
│   ├── backup_service.dart   # Backup & restore
│   └── export_service.dart   # PDF/CSV/Excel export
├── widgets/                  # Reusable components
│   ├── charts.dart           # Chart components
│   ├── budget_card.dart      # Budget progress cards
│   ├── transaction_list.dart # Transaction list view
│   └── animated_logo.dart    # Animated app logo
└── utils/                    # Utilities
    ├── constants.dart        # App constants & config
    └── formatters.dart       # Currency, date formatters
```

---

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.13+ |
| **State Management** | Provider, GetX |
| **Database** | Isar, Hive |
| **Charts** | Syncfusion Flutter Charts, FL Chart |
| **Security** | Local Auth, Encrypt, Flutter Secure Storage |
| **PDF** | PDF, Printing |
| **Export** | Excel, CSV |
| **UI** | Material 3, Flutter Animate, Lottie, Shimmer |
| **Notifications** | Flutter Local Notifications |
| **Images** | Image Picker, Image Cropper |
| **Calendar** | Table Calendar |
| **Connectivity** | Connectivity Plus |
| **Reviews** | In-App Review |

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.13 or higher
- Dart 3.0 or higher
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/proexpense_tracker.git
cd proexpense_tracker
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code (Isar & Hive)**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Generate app icons (optional)**
```bash
flutter pub run flutter_launcher_icons
```

5. **Run the app**
```bash
flutter run
```

---

## 📦 Build for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (Play Store)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## 🔐 Security Implementation

### Biometric Authentication
```dart
final LocalAuthentication localAuth = LocalAuthentication();
final bool canCheckBiometrics = await localAuth.canCheckBiometrics;
final bool isAuthenticated = await localAuth.authenticate(
  localizedReason: 'Authenticate to access your expenses',
  options: const AuthenticationOptions(
    stickyAuth: true,
    biometricOnly: false,
  ),
);
```

### Data Encryption
All sensitive data is encrypted using AES-256 encryption before storage.

---

## 📊 Export Formats

### PDF Report Features
- Professional header with app branding
- Summary section (Total Income, Expense, Balance)
- Transaction table with color coding
- Charts embedded in document
- Date range selection
- Print-ready format

### Excel Export
- Formatted spreadsheets
- Multiple sheets (Summary, Transactions, Analytics)
- Auto-calculated totals
- Filter and sort capabilities

---

## 🎨 Customization

### Change App Colors
Edit `lib/utils/constants.dart`:
```dart
static const Color primaryColor = Color(0xFF673AB7);
static const Color secondaryColor = Color(0xFF03DAC6);
```

### Add New Categories
Edit the `expenseCategories` or `incomeCategories` lists in `constants.dart`.

### Add New Language
Add locale to `supportedLocales` in `constants.dart` and create localization files.

---

## 📱 Play Store Submission Checklist

- [x] Adaptive icons configured
- [x] Privacy policy generated
- [x] Screenshots for multiple devices
- [x] Feature graphic (1024x500)
- [x] App description optimized
- [x] Content rating completed
- [x] Target API level 33+
- [x] 64-bit support enabled
- [x] In-app review integrated
- [x] Analytics ready (optional)

---

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run widget tests
flutter test --coverage

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📞 Support

For support, email support@proexpense.app or open an issue in the repository.

---

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- All package contributors
- Material Design team
- The Flutter community

---

## 📈 Roadmap

- [ ] Cloud Sync (Firebase/Supabase)
- [ ] Multi-currency conversion with real-time rates
- [ ] AI-powered spending insights
- [ ] Voice input for transactions
- [ ] Widget for home screen
- [ ] Wear OS support
- [ ] Web version
- [ ] Team/Family sharing
- [ ] Investment tracking
- [ ] Debt management

---

<div align="center">

**Made with ❤️ using Flutter**

[⭐ Star this repo](#) • [🐛 Report Issue](#) • [📖 Documentation](#)

</div>
