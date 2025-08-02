import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String griefStage;
  final String griefType;
  final String bio;
  final String? profileImageUrl;
  final DateTime joinDate;
  final DateTime lastActive;
  final bool profileVisible;
  final bool shareStory;
  final bool allowMatching;
  final String? fcmToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.griefStage,
    required this.griefType,
    required this.bio,
    this.profileImageUrl,
    required this.joinDate,
    required this.lastActive,
    required this.profileVisible,
    required this.shareStory,
    required this.allowMatching,
    this.fcmToken,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      griefStage: data['griefStage'] ?? '',
      griefType: data['griefType'] ?? '',
      bio: data['bio'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      joinDate: (data['joinDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      profileVisible: data['profileVisible'] ?? true,
      shareStory: data['shareStory'] ?? false,
      allowMatching: data['allowMatching'] ?? true,
      fcmToken: data['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'griefStage': griefStage,
      'griefType': griefType,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'joinDate': Timestamp.fromDate(joinDate),
      'lastActive': Timestamp.fromDate(lastActive),
      'profileVisible': profileVisible,
      'shareStory': shareStory,
      'allowMatching': allowMatching,
      'fcmToken': fcmToken,
    };
  }
}

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final String type;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return JournalEntry(
      id: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      type: data['type'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'type': type,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

class PrayerRequest {
  final String id;
  final String authorId;
  final String authorName;
  final String message;
  final bool isAnonymous;
  final int prayCount;
  final DateTime createdAt;
  final DateTime? lastPrayedAt;

  PrayerRequest({
    required this.id,
    required this.authorId,
    required this.authorName,
    required this.message,
    required this.isAnonymous,
    required this.prayCount,
    required this.createdAt,
    this.lastPrayedAt,
  });

  factory PrayerRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PrayerRequest(
      id: doc.id,
      authorId: data['authorId'] ?? '',
      authorName: data['authorName'] ?? '',
      message: data['message'] ?? '',
      isAnonymous: data['isAnonymous'] ?? false,
      prayCount: data['prayCount'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastPrayedAt: (data['lastPrayedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'message': message,
      'isAnonymous': isAnonymous,
      'prayCount': prayCount,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastPrayedAt': lastPrayedAt != null ? Timestamp.fromDate(lastPrayedAt!) : null,
    };
  }
}

class CompanionProfile {
  final String id;
  final String name;
  final String griefStage;
  final String griefType;
  final String bio;
  final bool allowMatching;
  final DateTime createdAt;
  final String? profileImageUrl;
  final int? compatibilityScore;

  CompanionProfile({
    required this.id,
    required this.name,
    required this.griefStage,
    required this.griefType,
    required this.bio,
    required this.allowMatching,
    required this.createdAt,
    this.profileImageUrl,
    this.compatibilityScore,
  });

  factory CompanionProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CompanionProfile(
      id: doc.id,
      name: data['name'] ?? '',
      griefStage: data['griefStage'] ?? '',
      griefType: data['griefType'] ?? '',
      bio: data['bio'] ?? '',
      allowMatching: data['allowMatching'] ?? true,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      profileImageUrl: data['profileImageUrl'],
      compatibilityScore: data['compatibilityScore'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'griefStage': griefStage,
      'griefType': griefType,
      'bio': bio,
      'allowMatching': allowMatching,
      'createdAt': Timestamp.fromDate(createdAt),
      'profileImageUrl': profileImageUrl,
      'compatibilityScore': compatibilityScore,
    };
  }
}

class ConnectionRequest {
  final String id;
  final String fromUserId;
  final String toUserId;
  final String status; // pending, accepted, declined
  final DateTime createdAt;
  final DateTime? updatedAt;

  ConnectionRequest({
    required this.id,
    required this.fromUserId,
    required this.toUserId,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory ConnectionRequest.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConnectionRequest(
      id: doc.id,
      fromUserId: data['fromUserId'] ?? '',
      toUserId: data['toUserId'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fromUserId': fromUserId,
      'toUserId': toUserId,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }
}

class ChatMessage {
  final String id;
  final String senderId;
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      senderId: data['senderId'] ?? '',
      message: data['message'] ?? '',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}