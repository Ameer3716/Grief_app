import 'package:firebase_auth/firebase_auth.dart';
import 'package:griefapp/services/firebase_service.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;
  static bool get isLoggedIn => _auth.currentUser != null;

  // Auth state stream
  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  static Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String griefStage,
    required String griefType,
    String? bio,
  }) async {
    try {
      final credential = await FirebaseService.signUpWithEmail(email, password);
      final user = credential.user;

      if (user != null) {
        // Create user profile in Firestore
        await FirebaseService.createUserProfile(
          userId: user.uid,
          name: name,
          email: email,
          griefStage: griefStage,
          griefType: griefType,
          bio: bio,
        );

        // Initialize notifications
        await FirebaseService.initializeNotifications();

        // Track sign up activity
        await FirebaseService.trackActivity('user_signup', {
          'griefType': griefType,
          'griefStage': griefStage,
        });

        return AuthResult.success(user);
      } else {
        return AuthResult.failure('Failed to create user account');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign in with email and password
  static Future<AuthResult> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseService.signInWithEmail(email, password);
      final user = credential.user;

      if (user != null) {
        // Initialize notifications
        await FirebaseService.initializeNotifications();

        // Update last active timestamp
        await FirebaseService.updateUserProfile(user.uid, {
          'lastActive': DateTime.now(),
        });

        // Track sign in activity
        await FirebaseService.trackActivity('user_signin');

        return AuthResult.success(user);
      } else {
        return AuthResult.failure('Failed to sign in');
      }
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      // Track sign out activity
      if (currentUserId != null) {
        await FirebaseService.trackActivity('user_signout');
      }

      await FirebaseService.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Send password reset email
  static Future<AuthResult> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseService.sendPasswordResetEmail(email);
      return AuthResult.success(null, message: 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Update user email
  static Future<AuthResult> updateEmail(String newEmail) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user signed in');
      }

      await user.updateEmail(newEmail);
      
      // Update email in Firestore
      await FirebaseService.updateUserProfile(user.uid, {
        'email': newEmail,
      });

      return AuthResult.success(user, message: 'Email updated successfully');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Update user password
  static Future<AuthResult> updatePassword(String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user signed in');
      }

      await user.updatePassword(newPassword);
      return AuthResult.success(user, message: 'Password updated successfully');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Delete user account
  static Future<AuthResult> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return AuthResult.failure('No user signed in');
      }

      // Track account deletion
      await FirebaseService.trackActivity('user_account_deleted');

      // Delete user data from Firestore (this should be handled by Cloud Functions)
      // For now, we'll just delete the auth account
      await user.delete();

      return AuthResult.success(null, message: 'Account deleted successfully');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Reauthenticate user (required for sensitive operations)
  static Future<AuthResult> reauthenticate(String password) async {
    try {
      final user = _auth.currentUser;
      if (user == null || user.email == null) {
        return AuthResult.failure('No user signed in');
      }

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);
      return AuthResult.success(user, message: 'Reauthentication successful');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_getAuthErrorMessage(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: ${e.toString()}');
    }
  }

  // Helper method to convert Firebase Auth errors to user-friendly messages
  static String _getAuthErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Please contact support.';
      case 'requires-recent-login':
        return 'Please sign in again to perform this action.';
      default:
        return 'Authentication failed: ${e.message}';
    }
  }
}

// Result class for auth operations
class AuthResult {
  final bool isSuccess;
  final User? user;
  final String? message;
  final String? error;

  AuthResult._({
    required this.isSuccess,
    this.user,
    this.message,
    this.error,
  });

  factory AuthResult.success(User? user, {String? message}) {
    return AuthResult._(
      isSuccess: true,
      user: user,
      message: message,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult._(
      isSuccess: false,
      error: error,
    );
  }
}