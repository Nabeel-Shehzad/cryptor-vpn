# Cryptor VPN

A secure and fast VPN application built with Flutter for iOS and Android.

## Features

- Secure VPN connection with military-grade encryption
- Real-time speed metrics (Download, Upload, Ping)
- Multiple server locations worldwide
- Beautiful and intuitive user interface
- Cross-platform support (iOS and Android)

## Requirements

- Flutter SDK: ^3.5.4
- iOS 11.0 or later
- Android 5.0 (API level 21) or later

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/cryptor_vpn.git
cd cryptor_vpn
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Building for Production

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## Architecture

The app follows a clean architecture pattern with the following structure:

- `lib/screens`: UI screens
- `lib/services`: Business logic and services
- `lib/models`: Data models
- `assets`: Images and other static resources

## Dependencies

- `flutter_vpn`: VPN connection management
- `network_info_plus`: Network information
- `provider`: State management
- `flutter_map`: Map visualization
- `shared_preferences`: Local storage
- Other dependencies can be found in `pubspec.yaml`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support, email support@cryptorvpn.com or open an issue in the GitHub repository.
