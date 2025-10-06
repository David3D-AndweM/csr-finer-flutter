<<<<<<< HEAD
# 🌍 CSR CRM - Corporate Social Responsibility Management Platform

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5.0-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Desktop-lightgrey.svg)](https://flutter.dev/multi-platform)

## 📘 Project Overview

CSR CRM is a comprehensive Flutter-based Corporate Social Responsibility Management Platform designed to help organizations plan, execute, monitor, and report on CSR initiatives with transparency, accountability, and measurable impact.

### 🎯 Key Objectives
- Enable CSR Managers to oversee all projects and budgets
- Allow Recipients (partners) to manage their projects and report progress
- Provide Finance Officers with tools for budget planning and tracking
- Offer M&E Officers real-time monitoring and KPI tracking
- Give Editors a basic CMS to publish blogs and project statistics
- Ensure data-driven decision-making through dashboards, analytics, and reporting

## 🏗️ Architecture

This project follows **Clean Architecture** principles with **MVVM** pattern, ensuring:
- **Separation of Concerns**: Clear boundaries between layers
- **Testability**: Easy unit and integration testing
- **Maintainability**: Modular and scalable codebase
- **Platform Independence**: Runs on Android, iOS, Web, and Desktop

```
lib/
├── core/                 # Core utilities, constants, and base classes
├── data/                 # Data layer (repositories, data sources, models)
├── domain/               # Business logic layer (entities, use cases)
├── presentation/         # UI layer (pages, widgets, view models)
└── main.dart            # Application entry point
```

## 👥 User Roles

### 1. CSR Manager
- Full system access and oversight
- Dashboard with all projects, milestones, budgets, and KPIs
- Approval workflows for milestones and financial reports
- Comprehensive reporting and analytics

### 2. Finance Officer
- Budget creation and management per financial year
- Fund allocation per sector (Education, Health, Infrastructure, Agriculture, Other)
- Expense tracking and utilization monitoring
- Financial transparency and accountability reports

### 3. Monitoring & Evaluation Officer
- Project milestone tracking and progress monitoring
- KPI calculation from survey responses
- Recipient project submission reviews
- Performance feedback and recommendations

### 4. Recipient (Partner Organizations)
- Multi-project management under signed MOUs
- Real-time milestone updates and progress reporting
- Survey completion and KPI contribution
- Direct messaging with CSR team

### 5. Editor
- Content management system for blogs and news
- Project statistics publication
- Media management and scheduling
- Public-facing content control

## 🚀 Features

### Core Modules
- **📊 Dashboard**: Role-specific dashboards with real-time data
- **📋 Project Management**: Multi-project support with milestone tracking
- **💰 Budget Management**: Multi-year budgets with sector allocation
- **📈 Survey & KPI System**: Automated KPI calculation from responses
- **💬 Messaging**: Real-time project-specific communication
- **📝 CMS**: Content management for blogs and statistics
- **📊 Reporting**: Comprehensive analytics with PDF/CSV export

### Technical Features
- **Multi-Platform**: Android, iOS, Web, Desktop support
- **Real-time Updates**: Live data synchronization
- **Role-based Access**: Secure authentication and authorization
- **Responsive Design**: Optimized for all screen sizes
- **Offline Support**: Local data caching and sync
- **File Management**: Document upload and management

## 🛠️ Technology Stack

- **Frontend**: Flutter 3.24.0+ with Dart 3.5.0+
- **State Management**: Riverpod 2.0+
- **Navigation**: Go Router
- **Local Storage**: Hive/SQLite
- **HTTP Client**: Dio
- **Dependency Injection**: GetIt
- **Testing**: Flutter Test, Mockito
- **Code Generation**: Build Runner, Freezed, JSON Annotation

## 📱 Platform Support

| Platform | Status | Version |
|----------|--------|---------|
| Android  | ✅ Supported | API 21+ |
| iOS      | ✅ Supported | iOS 12+ |
| Web      | ✅ Supported | Modern browsers |
| Desktop  | ✅ Supported | Windows, macOS, Linux |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24.0 or higher
- Dart SDK 3.5.0 or higher
- Android Studio / VS Code with Flutter extensions
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/David3D-AndweM/csr-finer-flutter.git
   cd csr-finer-flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d chrome    # Web
   flutter run -d macos     # macOS
   flutter run -d windows   # Windows
   ```

### Development Setup

1. **Environment Configuration**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

2. **Code Generation**
   ```bash
   # Watch for changes and auto-generate
   flutter packages pub run build_runner watch
   ```

3. **Testing**
   ```bash
   # Run all tests
   flutter test
   
   # Run with coverage
   flutter test --coverage
   ```

## 📚 Documentation

- [📐 Architecture Guide](docs/architecture/README.md)
- [🔌 API Documentation](docs/api/README.md)
- [👤 User Guides](docs/user-guides/README.md)
- [⚙️ Technical Specifications](docs/technical-specs/README.md)
- [🎨 Design System](docs/design/README.md)
- [🚀 Deployment Guide](docs/deployment/README.md)
- [🧪 Testing Guide](docs/testing/README.md)
- [🤝 Contributing](docs/contributing/README.md)

## 🧪 Testing

```bash
# Unit tests
flutter test test/unit/

# Widget tests
flutter test test/widget/

# Integration tests
flutter test test/integration/

# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Deployment

### Web Deployment
```bash
flutter build web --release
```

### Mobile Deployment
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Desktop Deployment
```bash
# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Linux
flutter build linux --release
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](docs/contributing/README.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Development Team

- **Lead Developer**: David AndweM
- **Project Type**: Advanced Flutter CSR Management System
- **Architecture**: Clean Architecture + MVVM
- **Status**: In Development

## 📞 Support

For support and questions:
- Create an issue on GitHub
- Contact the development team
- Check the documentation

---

**Built with ❤️ using Flutter for multi-platform CSR management**
=======
# csr_crm

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> fa78831b915188da7e020261e31476179d148135
