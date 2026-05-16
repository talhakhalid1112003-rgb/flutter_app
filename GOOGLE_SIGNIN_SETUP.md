# Google Sign-In Setup Guide

## Overview
This document provides complete instructions for Google authentication in the Smart Cricket Scorer app.

## ✅ Completed Steps

### 1. ✓ Firebase Console Configuration
- Enable Google sign-in provider in Firebase Authentication
- Google sign-in is **FREE** on the Firebase free plan
- No additional costs or billing required

### 2. ✓ Dependencies Added
Updated `pubspec.yaml` with:
```yaml
google_sign_in: ^6.2.0
```

### 3. ✓ Code Changes
- **AuthService**: Added `signInWithGoogle()` method
- **AuthController**: Added `signInWithGoogle()` state management
- **Login Screen**: Added Google sign-in button with divider
- **Signup Screen**: Added Google sign-in option with divider
- **New Widget**: Created `google_sign_in_button.dart` for reusable button

## 🔧 Next Steps (Manual Configuration)

### Android Configuration
1. Open `android/app/build.gradle.kts`
2. Ensure these plugins exist:
   ```kotlin
   plugins {
     id 'kotlin-android'
     id 'com.google.gms.google-services'
   }
   ```
3. Find your app's SHA-1 fingerprint:
   ```powershell
   cd android
   .\gradlew signingReport
   ```
4. Add SHA-1 to Firebase Console:
   - Go to Project Settings → Your Apps → Android
   - Paste the SHA-1 fingerprint

### iOS Configuration
1. iOS automatically uses OAuth credentials from Firebase Console
2. No manual configuration needed
3. Ensure Firebase pod is included (automatically handled by FlutterFire)

## 📱 How Google Sign-In Works in the App

### Login Flow
1. User taps "Sign in with Google" button on login screen
2. Google account selection dialog appears
3. User selects their Google account
4. App receives authentication token
5. Firebase authenticates the token
6. User profile is created/fetched from Firestore
7. User is redirected to sport-selection screen

### Sign-Up Flow
1. User can sign up using Google on the signup screen
2. Same authentication flow as login
3. User profile automatically created with Google data

## 🔒 Security Notes

1. **Free Tier Supported**: Google sign-in works on Firebase free plan
2. **No API Keys Exposed**: OAuth tokens handled securely by Firebase
3. **User Data**: Only email and display name collected from Google
4. **Firestore Rules**: Ensure users collection has proper read/write permissions

## ⚠️ Important: Firestore Security Rules

Update your `firestore.rules` to allow user profile creation:

```plaintext
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read: if request.auth.uid == userId;
      allow create: if request.auth.uid == userId;
      allow update: if request.auth.uid == userId;
      allow delete: if request.auth.uid == userId;
    }
  }
}
```

## 🚀 Testing

1. Run the app: `flutter run`
2. On login screen, tap "Sign in with Google"
3. Select your Google account
4. Verify user is logged in and profile created
5. Check Firestore database for user document in `/users/{uid}` collection

## 📊 User Profile Structure

When a user signs in with Google, the following profile is created in Firestore:

```json
{
  "userId": "firebase_uid",
  "name": "User's Display Name",
  "email": "user@gmail.com",
  "createdAt": "timestamp"
}
```

## ❓ Troubleshooting

### Google Sign-In Button Not Working
- Ensure SHA-1 fingerprint is added to Firebase Console
- Check that google_sign_in package is properly installed: `flutter pub get`

### "Sign-in cancelled" Message
- User pressed back button during Google account selection
- This is normal behavior, app returns to login screen

### Permission Denied Error
- Check Firestore rules (see security rules section above)
- Ensure `/users` collection exists or auto-create is enabled

### User Profile Not Created
- Check Firebase Authentication shows the user
- Verify Firestore rules allow user document creation
- Check browser console for Firestore errors

## 📝 Files Modified

1. `pubspec.yaml` - Added google_sign_in dependency
2. `lib/features/auth/services/auth_service.dart` - Added Google sign-in methods
3. `lib/features/auth/providers/auth_provider.dart` - Added Google sign-in logic
4. `lib/features/auth/screens/login_screen.dart` - Added Google sign-in button
5. `lib/features/auth/screens/signup_screen.dart` - Added Google sign-in option
6. `lib/features/auth/widgets/google_sign_in_button.dart` - New button widget

## ✨ Features Preserved

All existing functionalities remain unchanged:
- Email/password login
- Email/password signup
- Password reset
- All sport features (Cricket, Badminton)
- Tournament management
- Match scoring
- Team management
- Settings

## 🔄 Firebase Redirect Handling

The app automatically redirects users:
- Unauthenticated users → Login screen
- Authenticated users → Sport selection screen
- Works seamlessly with both email and Google sign-in

---

**Note**: This setup works on Firebase's FREE tier with no additional costs!
