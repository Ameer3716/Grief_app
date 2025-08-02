import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFunctions _functions = FirebaseFunctions.instance;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Authentication
  static User? get currentUser => _auth.currentUser;
  static String? get currentUserId => _auth.currentUser?.uid;

  static Future<UserCredential> signUpWithEmail(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // User Profile Management
  static Future<void> createUserProfile({
    required String userId,
    required String name,
    required String email,
    required String griefStage,
    required String griefType,
    String? bio,
    String? profileImageUrl,
  }) async {
    await _firestore.collection('users').doc(userId).set({
      'name': name,
      'email': email,
      'griefStage': griefStage,
      'griefType': griefType,
      'bio': bio ?? '',
      'profileImageUrl': profileImageUrl,
      'joinDate': FieldValue.serverTimestamp(),
      'lastActive': FieldValue.serverTimestamp(),
      'profileVisible': true,
      'shareStory': false,
      'allowMatching': true,
    });

    // Create companion profile if user allows matching
    await createCompanionProfile(userId, name, griefStage, griefType, bio ?? '');
  }

  static Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(userId).update(data);
  }

  static Future<DocumentSnapshot> getUserProfile(String userId) async {
    return await _firestore.collection('users').doc(userId).get();
  }

  // Companion System
  static Future<void> createCompanionProfile(
    String userId,
    String name,
    String griefStage,
    String griefType,
    String bio,
  ) async {
    await _firestore.collection('companions').doc(userId).set({
      'name': name,
      'griefStage': griefStage,
      'griefType': griefType,
      'bio': bio,
      'allowMatching': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<QuerySnapshot> getCompanionSuggestions(String userId) async {
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('suggestions')
        .get();
  }

  static Future<void> sendConnectionRequest(String fromUserId, String toUserId) async {
    await _firestore.collection('connectionRequests').add({
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> respondToConnectionRequest(String requestId, bool accept) async {
    await _firestore.collection('connectionRequests').doc(requestId).update({
      'status': accept ? 'accepted' : 'declined',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getConnectionRequests(String userId) {
    return _firestore
        .collection('connectionRequests')
        .where('toUserId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot> getUserConnections(String userId) {
    return _firestore
        .collection('connections')
        .where('participants', arrayContains: userId)
        .snapshots();
  }

  // Journal System
  static Future<void> createJournalEntry({
    required String userId,
    required String title,
    required String content,
    required String type,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('journals')
        .add({
      'title': title,
      'content': content,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getJournalEntries(String userId, String type) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('journals')
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  static Future<void> updateJournalEntry(
    String userId,
    String entryId,
    Map<String, dynamic> data,
  ) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('journals')
        .doc(entryId)
        .update(data);
  }

  static Future<void> deleteJournalEntry(String userId, String entryId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('journals')
        .doc(entryId)
        .delete();
  }

  // Prayer Wall
  static Future<void> createPrayerRequest({
    required String authorId,
    required String authorName,
    required String message,
    bool isAnonymous = false,
  }) async {
    await _firestore.collection('prayerRequests').add({
      'authorId': authorId,
      'authorName': isAnonymous ? 'Anonymous' : authorName,
      'message': message,
      'isAnonymous': isAnonymous,
      'prayCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getPrayerRequests() {
    return _firestore
        .collection('prayerRequests')
        .orderBy('createdAt', descending: true)
        .limit(50)
        .snapshots();
  }

  static Future<void> prayForRequest(String requestId, String userId) async {
    await _firestore
        .collection('prayerRequests')
        .doc(requestId)
        .collection('prayers')
        .doc(userId)
        .set({
      'userId': userId,
      'prayedAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<bool> hasUserPrayed(String requestId, String userId) async {
    final doc = await _firestore
        .collection('prayerRequests')
        .doc(requestId)
        .collection('prayers')
        .doc(userId)
        .get();
    return doc.exists;
  }

  // Remembrance Hub
  static Future<void> lightVirtualCandle(String userId, String? message) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('virtualCandles')
        .add({
      'litDate': FieldValue.serverTimestamp(),
      'message': message,
    });
  }

  static Stream<QuerySnapshot> getVirtualCandles(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('virtualCandles')
        .orderBy('litDate', descending: true)
        .snapshots();
  }

  static Future<void> addImportantDate({
    required String userId,
    required String title,
    required DateTime date,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('importantDates')
        .add({
      'title': title,
      'date': Timestamp.fromDate(date),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getImportantDates(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('importantDates')
        .orderBy('date')
        .snapshots();
  }

  // Content Management
  static Stream<QuerySnapshot> getDailyDevotions() {
    return _firestore
        .collection('dailyDevotions')
        .orderBy('date', descending: true)
        .snapshots();
  }

  static Future<DocumentSnapshot> getTodaysDevotions() async {
    final today = DateTime.now();
    final todayString = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    
    final query = await _firestore
        .collection('dailyDevotions')
        .where('date', isEqualTo: todayString)
        .limit(1)
        .get();
    
    if (query.docs.isNotEmpty) {
      return query.docs.first;
    }
    
    // Fallback to latest devotion
    final fallback = await _firestore
        .collection('dailyDevotions')
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    
    return fallback.docs.first;
  }

  static Stream<QuerySnapshot> getScriptureContent(String category) {
    return _firestore
        .collection('scriptureContent')
        .where('category', isEqualTo: category)
        .snapshots();
  }

  static Stream<QuerySnapshot> getFaithfulComfort(String type) {
    return _firestore
        .collection('faithfulComfort')
        .where('type', isEqualTo: type)
        .snapshots();
  }

  // Chat System
  static Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String message,
  }) async {
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'senderId': senderId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update chat's last message info
    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  static Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots();
  }

  // User Preferences
  static Future<void> updateUserPreferences(
    String userId,
    Map<String, dynamic> preferences,
  ) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .set(preferences, SetOptions(merge: true));
  }

  static Future<DocumentSnapshot> getUserPreferences(String userId) async {
    return await _firestore
        .collection('users')
        .doc(userId)
        .collection('preferences')
        .doc('settings')
        .get();
  }

  // Push Notifications
  static Future<void> initializeNotifications() async {
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    final token = await _messaging.getToken();
    if (token != null && currentUserId != null) {
      await _firestore.collection('users').doc(currentUserId).update({
        'fcmToken': token,
      });
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((token) {
      if (currentUserId != null) {
        _firestore.collection('users').doc(currentUserId).update({
          'fcmToken': token,
        });
      }
    });
  }

  // Activity Tracking
  static Future<void> trackActivity(String action, [Map<String, dynamic>? metadata]) async {
    if (currentUserId == null) return;

    try {
      final callable = _functions.httpsCallable('trackUserActivity');
      await callable.call({
        'action': action,
        'metadata': metadata ?? {},
      });
    } catch (e) {
      print('Error tracking activity: $e');
    }
  }

  // File Upload
  static Future<String> uploadFile(String path, List<int> data) async {
    final ref = _storage.ref().child(path);
    final uploadTask = ref.putData(data);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  static Future<void> deleteFile(String path) async {
    final ref = _storage.ref().child(path);
    await ref.delete();
  }
}