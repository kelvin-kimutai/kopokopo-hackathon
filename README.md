# FlutterConKE25 Registration & Payment App 🎉

A beautiful Flutter application for registering and paying for FlutterConKE25 conference tickets using the Kopo Kopo payment gateway. This app demonstrates the complete integration of the K2 Connect Flutter SDK with all its features.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## 🌟 Features

### Conference Features
- **Beautiful UI**: Modern dark theme with smooth animations
- **Multiple Ticket Types**: Early Bird, Regular, Student, and Corporate packages
- **Detailed Ticket Information**: View all benefits included with each ticket
- **Event Information**: Conference dates, venue, and schedule

### Payment Features (Exhaustive K2 Connect SDK Integration)
This app demonstrates **ALL** features of the Kopo Kopo Flutter SDK:

1. **Token Management**
   - Automatic access token generation
   - Token caching with expiry tracking
   - Token refresh when expired
   - Token revocation capability

2. **STK Push with UI** (Recommended Method)
   - Interactive bottom sheet payment flow
   - User-friendly phone number input
   - Real-time payment status updates
   - Success/error callbacks

3. **STK Push without UI** (Direct API)
   - Programmatic payment initiation
   - Full control over the payment flow
   - Direct API calls without UI elements
   - Custom status tracking implementation

4. **Payment Status Tracking**
   - Real-time status checking
   - Automatic polling (every 5 seconds)
   - Manual refresh capability
   - Detailed payment information display
   - Status timeline tracking

5. **Payment History**
   - View all past payment attempts
   - Filter by status (success, failed, pending)
   - Persistent storage using SharedPreferences
   - Quick access to payment details

### Animations
- Custom Flutter animations throughout the app
- Animated splash screen with logo
- Pulsing payment icons
- Smooth transitions between screens
- Loading animations

## 📸 Screenshots

```
[Splash Screen] → [Conference Home] → [Payment Selection] → [Payment Status]
```

## 🚀 Getting Started

### Prerequisites
- Flutter 3.0 or higher
- Dart 3.0 or higher
- A Kopo Kopo account (Sign up at https://app.kopokopo.com/)
- Your Kopo Kopo API credentials

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/flutterconke25-payment.git
cd flutterconke25-payment
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure environment variables**

Copy the example environment file and add your Kopo Kopo credentials:

```bash
cp env_example.txt .env
```

Edit `.env` and add your credentials:

```env
# Kopo Kopo API Configuration
K2_BASE_URL=sandbox.kopokopo.com

# Your Kopo Kopo API credentials from https://app.kopokopo.com/
K2_CLIENT_ID=your_client_id_here
K2_CLIENT_SECRET=your_client_secret_here
K2_API_KEY=your_api_key_here

# Your M-Pesa Till Number
K2_TILL_NUMBER=K000000

# Webhook callback URL (use ngrok or webhook.site for testing)
K2_CALLBACK_URL=https://webhook.site/your-unique-id
```

4. **Generate Stacked files** (if needed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. **Run the app**
```bash
flutter run
```

## 🔧 Configuration

### Getting Kopo Kopo Credentials

1. **Sign up** at https://app.kopokopo.com/
2. Navigate to **Settings** → **API Keys**
3. Create new API credentials for your application
4. Copy your:
   - Client ID
   - Client Secret
   - API Key
   - Till Number

### Setting up Webhook Callback

For testing, you can use:
- **Webhook.site**: https://webhook.site/ (Get a unique URL)
- **ngrok**: https://ngrok.com/ (For local development)

For production:
- Set up a proper backend endpoint to handle payment callbacks
- Implement webhook signature verification
- Store payment results in your database

## 📱 App Structure

```
lib/
├── app/                    # Stacked app configuration
│   ├── app.dart           # Routes and dependencies
│   ├── app.router.dart    # Generated routes
│   └── app.locator.dart   # Dependency injection
├── config/
│   └── app_config.dart    # App configuration
├── models/                # Data models
│   ├── ticket_type.dart
│   ├── payment_request.dart
│   └── payment_record.dart
├── services/              # Business logic
│   └── kopokopo_service.dart  # Comprehensive K2 SDK wrapper
├── ui/
│   ├── common/           # Shared UI components
│   ├── widgets/          # Reusable widgets
│   └── views/            # App screens
│       ├── splash/
│       ├── conference/
│       ├── payment/
│       ├── payment_tracking/
│       └── payment_history/
└── main.dart             # App entry point
```

## 💳 Payment Flow

### Method 1: Payment with UI (Recommended)
```dart
// User fills in details → Clicks Pay → Bottom sheet appears
// → User enters phone number → STK Push sent → Payment complete
```

### Method 2: Payment without UI (Advanced)
```dart
// User fills in all details including phone → Clicks Pay
// → Direct API call → Status tracking screen → Auto-refresh status
// → Payment complete
```

## 🎯 K2 Connect SDK Features Used

This app exhaustively demonstrates ALL features of the K2 Connect Flutter SDK:

### ✅ Token Service
- [x] `requestAccessToken()` - Get new access tokens
- [x] `revokeAccessToken()` - Revoke existing tokens
- [x] Token caching and expiry management
- [x] Automatic token refresh

### ✅ STK Service  
- [x] `requestPaymentBottomSheet()` - Payment with UI
- [x] `requestPayment()` - Direct API payment
- [x] `requestStatus()` - Check payment status
- [x] Success and error callbacks
- [x] Custom metadata support

### ✅ Additional Features
- [x] Comprehensive error handling
- [x] Payment history tracking
- [x] Persistent storage
- [x] Real-time status updates
- [x] Manual status refresh

## 📚 Key Files

### Service Layer
- **`kopokopo_service.dart`**: Complete wrapper around K2 Connect SDK with all features implemented

### Views
- **`splash_view.dart`**: Animated splash screen with initialization
- **`conference_home_view.dart`**: Ticket selection and conference info
- **`payment_view.dart`**: Payment method selection and customer details
- **`payment_tracking_view.dart`**: Real-time payment status tracking
- **`payment_history_view.dart`**: Historical payment records

### Models
- **`ticket_type.dart`**: Conference ticket definitions
- **`payment_request.dart`**: Payment request structure
- **`payment_record.dart`**: Payment tracking and history

## 🧪 Testing

### Testing in Sandbox Mode
1. Use sandbox credentials from Kopo Kopo
2. Use test phone numbers provided by Kopo Kopo
3. Monitor webhook calls using webhook.site
4. Check payment history in the app

### Test Scenarios
- ✅ Successful payment
- ✅ Failed payment (cancel STK prompt)
- ✅ Timeout scenarios
- ✅ Token refresh
- ✅ Payment history
- ✅ Status tracking

## 🎨 Customization

### Changing Colors
Edit `lib/ui/common/app_colors.dart`:
```dart
static const primaryColor = Color(0xFF0A0E27);
static const accentColor = Colors.blueAccent;
```

### Modifying Tickets
Edit ticket prices and details in `lib/models/ticket_type.dart`:
```dart
static const List<TicketType> availableTickets = [
  TicketType(
    name: 'Your Custom Ticket',
    price: 1000.00,
    // ...
  ),
];
```

## 📖 Documentation

- **K2 Connect Flutter SDK**: https://pub.dev/packages/k2_connect_flutter
- **Kopo Kopo API Docs**: https://api-docs.kopokopo.com/
- **Flutter**: https://flutter.dev/docs
- **Stacked Architecture**: https://pub.dev/packages/stacked

## 🐛 Troubleshooting

### Payment not working?
1. Check your `.env` configuration
2. Ensure you're using sandbox credentials for testing
3. Verify your till number is correct
4. Check webhook callback URL is accessible

### Token errors?
1. Verify your Client ID and Client Secret
2. Check API Key is valid
3. Ensure internet connection is stable

### Build errors?
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- **FlutterConKE25** - The first FlutterCon in Africa
- **Kopo Kopo** - Silver sponsor and payment gateway provider
- **Flutter Community** - For the amazing ecosystem

## 📞 Support

For issues related to:
- **App functionality**: Open an issue on GitHub
- **Kopo Kopo API**: Contact support@kopokopo.com
- **FlutterConKE25**: Visit https://fluttercondev.ke/

## 🎉 About FlutterConKE25

**Date**: 5th - 7th November 2025  
**Venue**: Golden Tulip Westlands Nairobi  
**Website**: https://fluttercondev.ke/

One ticket gets you access to both FlutterconKe and DroidconKe!

---

Made with ❤️ for the Flutter Community in Africa
