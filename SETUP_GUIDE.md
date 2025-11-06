# 🚀 Quick Setup Guide

## Step-by-Step Setup for FlutterConKE25 Payment App

### 1. Prerequisites Check ✅

Make sure you have:
- [ ] Flutter SDK installed (3.0 or higher)
- [ ] A code editor (VS Code, Android Studio, etc.)
- [ ] A Kopo Kopo account ([Sign up here](https://app.kopokopo.com/))
- [ ] An Android/iOS device or emulator

### 2. Get Your Kopo Kopo Credentials 🔑

1. Go to [Kopo Kopo Dashboard](https://app.kopokopo.com/)
2. Navigate to **Settings** → **API Keys**
3. Create new API credentials
4. Copy these values:
   - Client ID
   - Client Secret  
   - API Key
   - Till Number

### 3. Configure the App 🛠️

1. **Navigate to the project directory:**
```bash
cd /path/to/kopokopo
```

2. **Create your .env file:**
```bash
cp env_example.txt .env
```

3. **Edit the .env file** with your credentials:
```env
K2_BASE_URL=sandbox.kopokopo.com
K2_CLIENT_ID=your_actual_client_id
K2_CLIENT_SECRET=your_actual_client_secret
K2_API_KEY=your_actual_api_key
K2_TILL_NUMBER=K123456
K2_CALLBACK_URL=https://webhook.site/your-unique-id
```

### 4. Setup Webhook Testing 🪝

For testing callbacks, use one of these:

**Option A: Webhook.site (Easiest)**
1. Go to https://webhook.site/
2. Copy your unique URL
3. Paste it as `K2_CALLBACK_URL` in .env

**Option B: ngrok (For local backend)**
1. Install ngrok: https://ngrok.com/
2. Run: `ngrok http 3000` (or your port)
3. Copy the https URL
4. Add `/webhook` path if needed
5. Use as `K2_CALLBACK_URL` in .env

### 5. Install Dependencies 📦

```bash
flutter pub get
```

This will install:
- k2_connect_flutter (Kopo Kopo SDK)
- rive (Animations)
- stacked (Architecture)
- flutter_dotenv (Environment config)
- And all other dependencies...

### 6. Generate Code 🔨

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- Router files
- Dependency injection
- Other code generation

### 7. Run the App 🎉

**For Android:**
```bash
flutter run
```

**For iOS:**
```bash
flutter run -d ios
```

**For Web:**
```bash
flutter run -d chrome
```

### 8. Testing Payments 💳

#### Using Sandbox Mode:

1. **Select a ticket** in the app
2. **Fill in your details**:
   - First Name: Test
   - Last Name: User
   - Email: test@example.com
   - Phone: Use your actual Kenyan number (07XXXXXXXX)

3. **Choose payment method**:
   - **Quick Pay (With UI)**: Interactive bottom sheet
   - **Direct Payment**: Full form then direct API call

4. **Complete M-Pesa payment**:
   - Check your phone for STK push prompt
   - Enter your M-Pesa PIN
   - Confirm payment

5. **Monitor the webhook**:
   - Go to your webhook.site URL
   - Watch for callback from Kopo Kopo
   - See payment status update in real-time

### 9. Common Issues & Solutions 🔧

#### Issue: "Failed to load .env file"
**Solution:** 
- Ensure `.env` file exists in project root
- Check file name is exactly `.env` (not `.env.txt`)
- Verify file is not in `.gitignore` scope

#### Issue: "Invalid credentials"
**Solution:**
- Double-check credentials in .env
- Ensure no extra spaces in values
- Verify you're using sandbox credentials

#### Issue: "STK Push not received"
**Solution:**
- Verify phone number format (254XXXXXXXXX)
- Check M-Pesa is active on your phone
- Ensure SIM is in phone with network
- Try a different phone number

#### Issue: "Token expired"
**Solution:**
- App handles this automatically
- Try manual refresh
- Check internet connection

#### Issue: Build errors
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

### 10. App Features Overview 📱

#### Token Management
- ✅ Automatic token generation
- ✅ Token caching & refresh
- ✅ Token revocation

#### Payment Methods
- ✅ **With UI**: Bottom sheet payment flow
- ✅ **Without UI**: Direct API with tracking

#### Payment Tracking
- ✅ Real-time status updates
- ✅ Automatic polling (every 5 seconds)
- ✅ Manual refresh
- ✅ Detailed payment info

#### History
- ✅ View all payments
- ✅ Filter by status
- ✅ Persistent storage
- ✅ Quick access to details

### 11. Testing Checklist ✓

Before going live, test:
- [ ] Successful payment flow
- [ ] Failed payment (cancel STK)
- [ ] Timeout scenarios
- [ ] Payment history
- [ ] Token refresh
- [ ] Both payment methods
- [ ] Different ticket types
- [ ] Webhook callbacks

### 12. Going to Production 🚀

When ready for production:

1. **Update .env with production credentials:**
```env
K2_BASE_URL=api.kopokopo.com
K2_CLIENT_ID=production_client_id
K2_CLIENT_SECRET=production_client_secret
K2_API_KEY=production_api_key
K2_TILL_NUMBER=K789012
K2_CALLBACK_URL=https://yourdomain.com/api/webhook
```

2. **Setup production webhook endpoint:**
   - Create secure backend endpoint
   - Implement signature verification
   - Store payment results in database
   - Send confirmation emails

3. **Test thoroughly in production sandbox first**

4. **Enable production mode in Kopo Kopo dashboard**

5. **Deploy your backend**

6. **Release your app**

### 13. Support & Resources 📚

- **App Issues**: Open GitHub issue
- **Kopo Kopo API**: support@kopokopo.com
- **Documentation**: https://api-docs.kopokopo.com/
- **FlutterConKE**: https://fluttercondev.ke/

### 14. Quick Commands Reference 📝

```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Clean and rebuild
flutter clean && flutter pub get

# Run app
flutter run

# Run in debug mode
flutter run --debug

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Run tests
flutter test

# Check for outdated packages
flutter pub outdated

# Update packages
flutter pub upgrade
```

---

## 🎉 You're All Set!

Your FlutterConKE25 payment app is ready to go!

If you encounter any issues, check the troubleshooting section or refer to the main README.md.

Happy coding! 🚀

