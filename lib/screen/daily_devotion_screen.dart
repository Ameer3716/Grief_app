import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:griefapp/screen/community_screen.dart';
import 'package:griefapp/screen/grief_companion_screen.dart';
import 'package:griefapp/screen/grief_support_screen.dart';
import 'package:griefapp/screen/settings_profile_screen.dart';

class DailyDevotionScreen extends StatefulWidget {
  const DailyDevotionScreen({Key? key}) : super(key: key);

  @override
  State<DailyDevotionScreen> createState() => _DailyDevotionScreenState();
}

class _DailyDevotionScreenState extends State<DailyDevotionScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _playerState;
  bool get _isPlaying => _playerState == PlayerState.playing;
  static const String _audioUrl =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  bool _morningEnabled = false;
  bool _eveningEnabled = false;

  final List<String> _affirmations = [
    "I am held in God's loving embrace.",
    'My faith is my strength.',
    'I am not alone in my grief.',
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(_audioUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F6),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'Daily Devotion',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Finding Peace in the Storm',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'In times of sorrow, remember that God is your refuge and strength. He is always present, offering comfort and guidance. Trust in His unwavering love, and find peace in His embrace.',
              style: TextStyle(height: 1.4, fontSize: 14),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9831F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                label: Flexible(
                  child: Text(
                    _isPlaying ? 'Pause Devotion' : 'Listen to Devotion',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                onPressed: _toggleAudio,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Affirmations',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 12),
            ..._affirmations.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: const Color(0xFFEFEFEF),
                      ),
                      child: const Icon(Icons.check, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Reminders',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: 12),
            _buildReminderTile(
              title: 'Morning Reflection',
              time: '8:00 AM',
              value: _morningEnabled,
              onChanged: (v) {
                setState(() => _morningEnabled = v);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_morningEnabled
                      ? 'Morning reminder set for 8:00 AM.'
                      : 'Morning reminder turned off.'),
                  duration: const Duration(seconds: 2),
                ));
              },
            ),
            _buildReminderTile(
              title: 'Evening Reflection',
              time: '8:00 PM',
              value: _eveningEnabled,
              onChanged: (v) {
                setState(() => _eveningEnabled = v);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(_eveningEnabled
                      ? 'Evening reminder set for 8:00 PM.'
                      : 'Evening reminder turned off.'),
                  duration: const Duration(seconds: 2),
                ));
              },
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // This is the Home tab
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const GriefCompanionScreen()));
          } else if (index == 2) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const CommunityScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (_) => const GriefSupportScreen()));
          } else if (index == 4) {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SettingsProfileScreen()));
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Companion'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks_outlined), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildReminderTile({
    required String title,
    required String time,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFFD9831F),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}