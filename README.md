# 💰 ProExpense Tracker - Professional Flutter Expense Manager

A fully-featured, professional-grade expense tracking application built with Flutter. Designed for Android with a responsive UI, it offers comprehensive financial management tools including graphical analytics, PDF/Excel exports, data sharing, local storage, and advanced security features.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green.svg)

## 🌟 Key Features

### 📊 Advanced Analytics & Visualization
- **Interactive Charts**: Beautiful Pie charts for category breakdown and Bar charts for daily/weekly trends using `fl_chart`.
- **Budget Tracking**: Set monthly budgets per category and visualize progress with color-coded indicators.
- **Insights Dashboard**: View average daily spend, highest expense, and income vs. expense ratios.

### 💾 Data Management & Export
- **Local Storage**: High-performance NoSQL database using **Isar** for instant data retrieval and offline capability.
- **PDF Reports**: Generate professional, formatted PDF reports with summaries and transaction tables.
- **Excel & CSV Export**: Export data to `.xlsx` and `.csv` formats for further analysis in spreadsheet software.
- **Data Sharing**: Share reports instantly via WhatsApp, Email, Drive, or any installed app.
- **Backup & Restore**: Export entire database to JSON and restore it on another device or after reinstalling.

### 🔒 Security & Privacy
- **App Lock**: Secure your financial data with a 4-digit PIN or Biometric authentication (Fingerprint/FaceID).
- **Private Mode**: Hide sensitive amounts in the dashboard when in public view.

### ⚙️ Customization & Usability
- **Responsive Design**: Optimized for all Android screen sizes (phones, tablets, foldables).
- **Dark/Light Theme**: Full theme support with system sync or manual toggle.
- **Multi-Currency**: Support for different currency symbols and formatting.
- **Recurring Transactions**: Automate daily, weekly, or monthly entries for salaries, rent, subscriptions, etc.
- **Advanced Filtering**: Filter history by date ranges, categories, and transaction types.
- **Search**: Instant search through transaction history by name or note.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code
- An Android device or emulator

### Installation

1.  **Clone the repository**
    ```bash
    git clone https://github.com/yourusername/proexpense-tracker.git
    cd proexpense-tracker
    ```

2.  **Install Dependencies**
    ```bash
    flutter pub get
    ```

3.  **Generate Code (Isar & Build Runner)**
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```

4.  **Run the App**
    ```bash
    flutter run
    ```

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Local Database**: Isar (NoSQL, ACID compliant)
- **State Management**: Provider
- **Charts**: fl_chart
- **PDF Generation**: pdf, printing
- **Excel Export**: excel
- **Security**: local_auth
- **Sharing**: share_plus

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point, theme setup, DI
├── models/
│   ├── expense.dart          # Transaction model
│   ├── budget.dart           # Budget model
│   └── settings.dart         # User preferences model
├── pages/
│   ├── home_page.dart        # Main dashboard with tabs
│   ├── stats_page.dart       # Detailed analytics
│   ├── budget_page.dart      # Budget management
│   └── settings_page.dart    # App settings & backup
├── services/
│   ├── database_service.dart # Isar CRUD operations
│   ├── export_service.dart   # PDF, Excel, CSV logic
│   ├── auth_service.dart     # Biometric/PIN logic
│   └── backup_service.dart   # JSON import/export
├── widgets/
│   ├── charts/               # Reusable chart components
│   ├── transaction_list.dart # History list with swipe actions
│   └── budget_card.dart      # Budget progress indicator
└── utils/
    ├── constants.dart        # App constants
    └── formatters.dart       # Currency/Date formatters
```

## 🔐 Security Note
Biometric authentication requires specific permissions in `AndroidManifest.xml`. Ensure you have tested on a physical device with biometric hardware enabled for full functionality.

## 🤝 Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Contact
For questions or support, please reach out via the repository issues.

---
*Built with ❤️ using Flutter*
