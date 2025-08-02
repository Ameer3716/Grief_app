# Firebase Deployment Guide for SOULNEST

## Prerequisites

1. Install Firebase CLI:
```bash
npm install -g firebase-tools
```

2. Login to Firebase:
```bash
firebase login
```

3. Create a new Firebase project at https://console.firebase.google.com/

## Initial Setup

1. Initialize Firebase in your project:
```bash
firebase init
```

Select the following services:
- Firestore
- Functions
- Storage
- Hosting (optional)

2. Configure your project:
```bash
firebase use --add [your-project-id]
```

## Firestore Setup

1. Deploy Firestore rules and indexes:
```bash
firebase deploy --only firestore
```

2. Import sample data (optional):
```bash
# Install the Firebase Admin SDK for data import
npm install -g node-firestore-import-export

# Import sample data
firestore-import -a path/to/service-account-key.json -b firebase/sample_data.json -n [collection-name]
```

## Cloud Functions Setup

1. Navigate to functions directory:
```bash
cd firebase/functions
```

2. Install dependencies:
```bash
npm install
```

3. Deploy functions:
```bash
firebase deploy --only functions
```

## Storage Setup

1. Deploy storage rules:
```bash
firebase deploy --only storage
```

2. Create storage buckets structure:
- `/users/{userId}/profile-images/`
- `/users/{userId}/journal-attachments/`
- `/users/{userId}/remembrance-photos/`
- `/content/devotion-audio/`
- `/content/meditation-audio/`
- `/content/worship-music/`

## Flutter App Configuration

1. Add Firebase to your Flutter app:
```bash
flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage cloud_functions firebase_messaging
```

2. Configure Firebase for Android:
- Download `google-services.json` from Firebase Console
- Place it in `android/app/`
- Update `android/app/build.gradle`

3. Configure Firebase for iOS:
- Download `GoogleService-Info.plist` from Firebase Console
- Add it to `ios/Runner/` in Xcode

4. Initialize Firebase in your Flutter app:
```dart
// In main.dart
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
```

## Security Configuration

1. Enable Authentication:
- Go to Firebase Console > Authentication
- Enable Email/Password sign-in method
- Configure authorized domains

2. Set up App Check (recommended):
- Enable App Check in Firebase Console
- Configure for production apps

## Push Notifications Setup

1. Configure FCM:
- Generate server key in Firebase Console
- Add to your app's configuration

2. Handle background messages:
```dart
// Add to main.dart
FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}
```

## Testing

1. Use Firebase Emulators for local testing:
```bash
firebase emulators:start
```

2. Run tests against emulators:
```bash
flutter test
```

## Production Deployment

1. Deploy all services:
```bash
firebase deploy
```

2. Monitor deployment:
- Check Firebase Console for any errors
- Monitor Cloud Functions logs
- Test all features in production

## Monitoring and Analytics

1. Enable Firebase Analytics
2. Set up Crashlytics for error reporting
3. Monitor Performance with Firebase Performance Monitoring
4. Set up alerts for critical functions

## Backup Strategy

1. Set up automated Firestore backups:
```bash
# Create a backup schedule
gcloud firestore databases backup-schedules create \
    --database=DATABASE_ID \
    --recurrence=weekly \
    --retention=14w
```

2. Export user data functionality for GDPR compliance

## Cost Optimization

1. Monitor usage in Firebase Console
2. Set up billing alerts
3. Optimize Firestore queries to reduce reads
4. Use Firebase Functions efficiently
5. Implement proper caching strategies

## Security Checklist

- [ ] Firestore security rules are properly configured
- [ ] Storage security rules are in place
- [ ] Authentication is properly set up
- [ ] App Check is enabled for production
- [ ] API keys are properly secured
- [ ] User data is properly encrypted
- [ ] GDPR compliance measures are in place

## Maintenance

1. Regularly update Firebase SDKs
2. Monitor and optimize Cloud Functions performance
3. Review and update security rules as needed
4. Clean up old data periodically
5. Monitor costs and usage patterns