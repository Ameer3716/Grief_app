import 'package:flutter/material.dart';
import 'package:griefapp/screen/community_screen.dart';
import 'package:griefapp/screen/daily_devotion_screen.dart';
import 'package:griefapp/screen/grief_companion_screen.dart';
import 'package:griefapp/screen/settings_profile_screen.dart';

class GriefSupportScreen extends StatefulWidget {
  const GriefSupportScreen({Key? key}) : super(key: key);

  @override
  State<GriefSupportScreen> createState() => _GriefSupportScreenState();
}

class _GriefSupportScreenState extends State<GriefSupportScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  int _currentIndex = 3; // Resources tab is now index 3

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color hint = const Color(0xFFB9B5B3); // grey for unselected tab

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: const Text(
          'Scripture & Reflection', // Updated title
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40),
          child: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 16),
            child: TabBar(
              controller: _tab,
              isScrollable: true,
              indicatorColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 20),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              labelColor: Colors.black,
              unselectedLabelColor: hint,
              tabs: const [
                Tab(text: 'Comfort'),
                Tab(text: 'Strength'),
                Tab(text: 'Hope'),
                Tab(text: 'Renewal'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildScriptureList(_comfortVerses),
          _buildScriptureList(_strengthVerses),
          _buildScriptureList(_hopeVerses),
          _buildScriptureList(_renewalVerses),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _currentIndex) return;

          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DailyDevotionScreen()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const GriefCompanionScreen()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const CommunityScreen()),
            );
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsProfileScreen()),
            );
          }
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: hint,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Companion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined),
            label: 'Community',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmarks),
            label: 'Resources',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildScriptureList(List<({String title, String text})> verses) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      separatorBuilder: (_, __) => const SizedBox(height: 24),
      itemCount: verses.length,
      itemBuilder: (_, i) {
        final v = verses[i];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.3),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_arrow_rounded, size: 14),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  v.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              v.text,
              style: const TextStyle(
                  fontSize: 13, height: 1.5, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              'Reflection Prompt',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            const TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'What does this verse mean to you today?',
                filled: true,
                fillColor: Color(0xFFF0F0F0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            ),
          ],
        );
      },
    );
  }
}

// --- Scripture Data ---
const _comfortVerses = [
  (
    title: 'Psalm 34:18',
    text:
        'The Lord is close to the brokenhearted and saves those who are crushed in spirit.',
  ),
  (
    title: 'Matthew 5:4',
    text: 'Blessed are those who mourn, for they will be comforted.',
  ),
  (
    title: '2 Corinthians 1:3-4',
    text:
        'Praise be to the God and Father of our Lord Jesus Christ, the Father of compassion and the God of all comfort, who comforts us in all our troubles...',
  ),
];

const _strengthVerses = [
  (
    title: 'Isaiah 41:10',
    text:
        'So do not fear, for I am with you; do not be dismayed, for I am your God. I will strengthen you and help you; I will uphold you with my righteous right hand.',
  ),
  (
    title: 'Philippians 4:13',
    text: 'I can do all this through him who gives me strength.',
  ),
];

const _hopeVerses = [
  (
    title: 'Romans 15:13',
    text:
        'May the God of hope fill you with all joy and peace as you trust in him, so that you may overflow with hope by the power of the Holy Spirit.',
  ),
  (
    title: 'Jeremiah 29:11',
    text:
        '"For I know the plans I have for you,” declares the Lord, “plans to prosper you and not to harm you, plans to give you hope and a future."',
  ),
];

const _renewalVerses = [
  (
    title: '2 Corinthians 5:17',
    text:
        'Therefore, if anyone is in Christ, the new creation has come: The old has gone, the new is here!',
  ),
  (
    title: 'Isaiah 40:31',
    text:
        'but those who hope in the Lord will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.',
  ),
];