import 'package:flutter/material.dart';
import 'package:griefapp/screen/daily_devotion_screen.dart';
import 'package:griefapp/screen/faithful_comfort_screen.dart';
import 'package:griefapp/screen/grief_companion_screen.dart';
import 'package:griefapp/screen/grief_support_screen.dart';
import 'package:griefapp/screen/journal_screen.dart';
import 'package:griefapp/screen/prayer_requests_screen.dart';
import 'package:griefapp/screen/remembrance_screen.dart';
import 'package:griefapp/screen/settings_profile_screen.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 0,
        title: const Text(
          'Community',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── JOURNAL SECTION ─────
            const _JournalSection(),
            const SizedBox(height: 28),

            // ───── PRAYER SECTION ─────
            const _PrayerSection(),
            const SizedBox(height: 28),

            // ───── REMEMBRANCE SECTION ─────
            const _RemembranceSection(),
            const SizedBox(height: 28),

            // ───── FAITHFUL COMFORT SECTION ─────
            const _FaithfulComfortSection(),
            const SizedBox(height: 40),
            
            // GRIEF COMPANION SECTION HAS BEEN REMOVED
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // This is the Community tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const DailyDevotionScreen()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const GriefCompanionScreen()));
          } else if (index == 3) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const GriefSupportScreen()));
          } else if (index == 4) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const SettingsProfileScreen()));
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
}

// ───── JOURNAL SECTION ─────
class _JournalSection extends StatelessWidget {
  const _JournalSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _JournalItem(
          label: 'Prayers',
          assetPath: 'assets/images/prayers.jpg',
          fallbackUrl: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
        ),
        SizedBox(height: 28),
        _JournalItem(
          label: 'Letters',
          assetPath: 'assets/images/letters.jpg',
          fallbackUrl: 'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70',
        ),
        SizedBox(height: 28),
        _JournalItem(
          label: 'Gratitude',
          assetPath: 'assets/images/gratitude.jpg',
          fallbackUrl: 'https://images.unsplash.com/photo-1514846326719-9086d4c7883b',
        ),
      ],
    );
  }
}

class _JournalItem extends StatelessWidget {
  final String label;
  final String assetPath;
  final String fallbackUrl;

  const _JournalItem({
    required this.label,
    required this.assetPath,
    required this.fallbackUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JournalScreen()),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                assetPath,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.network(
                  fallbackUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───── PRAYER SECTION ─────
class _PrayerSection extends StatelessWidget {
  const _PrayerSection();

  @override
  Widget build(BuildContext context) {
    const _orange = Color(0xFFDA7A25);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Share a Prayer Request',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Share what\'s on your heart...',
            filled: true,
            fillColor: Color(0xFFF0F0F0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('Your prayer has been shared with the community.')),
              );
            },
            child: const Text('Submit',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 24),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PrayerRequestsScreen()),
            );
          },
          child: const Row(
            children: [
              Text(
                'Community Prayer Wall',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Spacer(),
              Text(
                'View All',
                style: TextStyle(color: _orange, fontWeight: FontWeight.w600),
              ),
              Icon(Icons.arrow_forward_ios, color: _orange, size: 14),
            ],
          ),
        ),
        const SizedBox(height: 16),
        ..._dummyRequests
            .take(1)
            .map((r) => _PrayerCard(r)), // Show only the first one as a preview
      ],
    );
  }
}

class _PrayerCard extends StatelessWidget {
  final _PrayerRequest data;
  const _PrayerCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 22, backgroundImage: NetworkImage(data.avatarUrl)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Posted ${data.daysAgo} days ago',
                    style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                const SizedBox(height: 4),
                Text(data.message,
                    style: const TextStyle(height: 1.4),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            children: [
              const Text('🙏', style: TextStyle(fontSize: 20)),
              const SizedBox(height: 4),
              Text(data.count.toString(), style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerRequest {
  final String name;
  final int daysAgo;
  final String message;
  final int count;
  final String avatarUrl;

  const _PrayerRequest({
    required this.name,
    required this.daysAgo,
    required this.message,
    required this.count,
    required this.avatarUrl,
  });
}

const _dummyRequests = [
  _PrayerRequest(
    name: 'Sarah M.',
    daysAgo: 2,
    count: 12,
    message: 'Please pray for my family as we navigate this difficult time.',
    avatarUrl: 'https://i.pravatar.cc/100?img=47',
  ),
  _PrayerRequest(
    name: 'David L.',
    daysAgo: 3,
    count: 25,
    message: 'Pray for my friend Mark, who is battling a serious illness.',
    avatarUrl: 'https://i.pravatar.cc/100?img=12',
  ),
];

// ───── REMEMBRANCE SECTION ─────
class _RemembranceSection extends StatelessWidget {
  const _RemembranceSection();

  static const _orange = Color(0xFFDB7A1B);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    return _buildBlock(
      title: 'Remembrance Hub',
      description:
          'Light virtual candles, mark important dates, and write letters to heaven.',
      button: 'Visit Hub',
      theme: theme,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RemembranceScreen()),
        );
      },
    );
  }

  Widget _buildBlock({
    required String title,
    required String description,
    required String button,
    required TextTheme theme,
    required VoidCallback onPressed,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Text(description,
            style: theme.bodyMedium?.copyWith(height: 1.4, color: Colors.grey[700])),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: onPressed,
            child: Text(button,
                style: theme.labelLarge?.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

// ───── FAITHFUL COMFORT SECTION ─────
class _FaithfulComfortSection extends StatelessWidget {
  const _FaithfulComfortSection();
  static const _orange = Color(0xFFDA7A25);

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Faithful Comfort',
          style: theme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        Text(
          'Find peace through guided meditations, worship music, and night blessings.',
          style: theme.bodyMedium
              ?.copyWith(height: 1.4, color: Colors.grey[700]),
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FaithfulComfortScreen()),
              );
            },
            child: Text('Explore Comfort',
                style: theme.labelLarge?.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}