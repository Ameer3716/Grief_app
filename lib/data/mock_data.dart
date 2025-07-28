// lib/data/mock_data.dart
import 'package:flutter/material.dart';

// --- User Data Singleton ---
class UserData {
  static final UserData _instance = UserData._internal();
  factory UserData() => _instance;
  UserData._internal();

  // This will store the selection from the ExperienceScreen to be used for matching
  String? currentUserGriefType;
}


// --- Journal and Letter Models & Data ---

class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime date;

  JournalEntry({required this.title, required this.content, required this.date})
      : id = UniqueKey().toString();
}

class JournalData {
  // Using a singleton pattern to keep data consistent across the app session
  static final JournalData _instance = JournalData._internal();
  factory JournalData() => _instance;
  JournalData._internal();

  final Map<String, List<JournalEntry>> entries = {
    'Prayers': [
      JournalEntry(title: "A Prayer for Strength", content: "Lord, grant me the strength to face this day...", date: DateTime.now().subtract(const Duration(days: 2))),
      JournalEntry(title: "Morning Prayer", content: "Thank you for the gift of a new day...", date: DateTime.now().subtract(const Duration(days: 5))),
    ],
    'Gratitude': [
       JournalEntry(title: "A Moment of Peace", content: "I am grateful for the quiet moments this afternoon that brought me peace.", date: DateTime.now().subtract(const Duration(days: 1))),
    ],
    'Letters to Heaven': [
       JournalEntry(title: "Thinking of You", content: "My dearest, I saw a cardinal today and it made me think of you...", date: DateTime.now().subtract(const Duration(days: 10))),
    ],
  };

  void addEntry(String type, JournalEntry entry) {
    if (entries.containsKey(type)) {
      entries[type]!.insert(0, entry);
    } else {
      entries[type] = [entry];
    }
  }
}

// --- Companion Model ---

enum ConnectionStatus { none, requested, connected }

class GriefCompanionProfile {
  final String name;
  final String griefStage;
  final String griefType;
  final String bio;
  final String avatarUrl;
  ConnectionStatus status; // Make status mutable

  GriefCompanionProfile({
    required this.name,
    required this.griefStage,
    required this.griefType,
    required this.bio,
    required this.avatarUrl,
    this.status = ConnectionStatus.none,
  });
}