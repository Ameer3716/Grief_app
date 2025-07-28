import 'package:flutter/material.dart';
import 'package:griefapp/data/mock_data.dart';
import 'package:griefapp/screen/chat_screen.dart';
import 'package:griefapp/screen/companion_profile_detail_screen.dart';
// Import other main screens for navigation
import 'package:griefapp/screen/community_screen.dart';
import 'package:griefapp/screen/daily_devotion_screen.dart';
import 'package:griefapp/screen/grief_support_screen.dart';
import 'package:griefapp/screen/settings_profile_screen.dart';

class GriefCompanionScreen extends StatefulWidget {
  const GriefCompanionScreen({Key? key}) : super(key: key);

  @override
  State<GriefCompanionScreen> createState() => _GriefCompanionScreenState();
}

class _GriefCompanionScreenState extends State<GriefCompanionScreen> {
  // --- State for filtering and companion list ---
  late List<GriefCompanionProfile> _allCompanions;
  List<GriefCompanionProfile> _filteredCompanions = [];
  String? _selectedGriefType;
  final List<String> _griefTypes = [
    'All',
    'Loss of a loved one',
    'Health challenge',
    'Career setback'
  ];

  @override
  void initState() {
    super.initState();
    // Initialize with mock data
    _allCompanions = [
      GriefCompanionProfile(
        name: 'Anna S.',
        griefStage: 'Early Grief',
        griefType: 'Loss of a loved one',
        bio:
            'Seeking a compassionate soul to share stories and find comfort together. In the early stages of my journey and hoping to find someone who understands.',
        avatarUrl: 'https://i.pravatar.cc/150?img=50',
      ),
      GriefCompanionProfile(
        name: 'Mark T.',
        griefStage: 'Acceptance',
        griefType: 'Health challenge',
        bio:
            'Looking for someone to share insights on finding strength after a long battle. I am in a place of acceptance but value mutual support.',
        avatarUrl: 'https://i.pravatar.cc/150?img=60',
      ),
      GriefCompanionProfile(
        name: 'Jessica L.',
        griefStage: 'Reconstruction',
        griefType: 'Career setback',
        bio:
            'Ready to rebuild and support others doing the same. Let\'s inspire each other to find new paths and purposes.',
        avatarUrl: 'https://i.pravatar.cc/150?img=70',
      ),
      GriefCompanionProfile(
        name: 'David R.',
        griefStage: 'Working Through It',
        griefType: 'Loss of a loved one',
        bio:
            'It\'s been a while, but some days are still hard. I would like to connect with someone who is also further along but still values a companion.',
        avatarUrl: 'https://i.pravatar.cc/150?img=12',
      ),
    ];
    
    // Pre-set one companion as 'connected' to demonstrate the chat button functionality
    _allCompanions[1].status = ConnectionStatus.connected;

    _filteredCompanions = _allCompanions;
    _selectedGriefType = 'All';
  }

  void _filterCompanions(String? type) {
    setState(() {
      _selectedGriefType = type;
      if (type == null || type == 'All') {
        _filteredCompanions = _allCompanions;
      } else {
        _filteredCompanions =
            _allCompanions.where((c) => c.griefType == type).toList();
      }
    });
  }

  void _updateConnectionStatus(
      GriefCompanionProfile profile, ConnectionStatus newStatus) {
    setState(() {
      profile.status = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grief Companion'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          // --- Filter UI ---
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedGriefType,
              decoration: InputDecoration(
                labelText: 'Filter by Experience',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: _griefTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: _filterCompanions,
            ),
          ),
          // --- Companion List ---
          Expanded(
            child: _filteredCompanions.isEmpty
              ? const Center(
                  child: Text(
                    'No companions match this filter.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredCompanions.length,
              itemBuilder: (context, index) {
                final companion = _filteredCompanions[index];
                return _CompanionProfileCard(
                  profile: companion,
                  onConnect: () {
                    _updateConnectionStatus(
                        companion, ConnectionStatus.requested);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Connection request sent to ${companion.name}!')),
                    );
                  },
                  onViewProfile: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CompanionProfileDetailScreen(profile: companion),
                      ),
                    );
                  },
                  onMessage: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ChatScreen(companionName: companion.name),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // This is the Companion tab
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const DailyDevotionScreen()));
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
          BottomNavigationBarItem(icon: Icon(Icons.favorite), activeIcon: Icon(Icons.favorite), label: 'Companion'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Community'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmarks_outlined), label: 'Resources'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _CompanionProfileCard extends StatelessWidget {
  final GriefCompanionProfile profile;
  final VoidCallback onConnect;
  final VoidCallback onViewProfile;
  final VoidCallback onMessage;

  const _CompanionProfileCard({
    required this.profile,
    required this.onConnect,
    required this.onViewProfile,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profile.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${profile.griefStage} | ${profile.griefType}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              profile.bio,
              style: const TextStyle(fontSize: 14, height: 1.4),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: onViewProfile,
                  child: const Text('View'),
                ),
                const SizedBox(width: 8),
                // This is the updated button logic
                if (profile.status == ConnectionStatus.connected)
                  ElevatedButton.icon(
                    onPressed: onMessage, // This navigates to the ChatScreen
                    icon: const Icon(Icons.chat_bubble_outline, size: 16),
                    label: const Text('Chat'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // A distinct color for the chat button
                      foregroundColor: Colors.white,
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed:
                        profile.status == ConnectionStatus.none ? onConnect : null,
                    child: Text(profile.status == ConnectionStatus.none
                        ? 'Connect'
                        : 'Requested'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}