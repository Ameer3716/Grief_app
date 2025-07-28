import 'package:flutter/material.dart';

class SettingsProfileScreen extends StatefulWidget {
  const SettingsProfileScreen({Key? key}) : super(key: key);

  @override
  State<SettingsProfileScreen> createState() => _SettingsProfileScreenState();
}

class _SettingsProfileScreenState extends State<SettingsProfileScreen> {
  // Switch states
  bool _dailyDevotion = false;
  bool _prayerReminder = false;
  bool _communityUpdates = false;
  bool _compassionMessages = false;
  bool _nightBriefing = false;

  bool _profileVisible = false;
  bool _shareStory = false;
  bool _allowMatching = false;

  final Color primaryOrange = const Color(0xFFED7A1C);
  final Color cardBackground = const Color(0xFFE6E3E3); // more grayish

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6F6),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── Hero Image with Button ───
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: false,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {
                    // TODO: Implement audio settings/volume control
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Audio settings functionality to be implemented!')),
                    );
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        'assets/images/avatar.jpg',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.network(
                          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=600&q=60',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4, // slightly lower
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        ),
                        onPressed: () {
                          // TODO: Implement free trial action
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Free trial functionality to be implemented!')),
                          );
                        },
                        child: const Text(
                          'Free Trial',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ─── Profile Options Section ───
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Column(
                  children: [
                    _buildNotificationSection(),
                    const SizedBox(height: 12),
                    _buildPrivacySection(),
                    const SizedBox(height: 12),
                    _buildSupportSection(),
                    const SizedBox(height: 20),

                    // Save Changes (gray card style)
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement save changes functionality
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Changes saved!')),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Sign Out button (black text + icon + orange border)
                    OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Implement sign out functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signed out!')),
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.black),
                      label: const Text(
                        'Sign Out',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryOrange),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        minimumSize: const Size.fromHeight(48),
                        foregroundColor: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ────────────────────────────────────────────────
  Widget _buildNotificationSection() {
    return _SettingsCard(
      icon: Icons.notifications_none_rounded,
      title: 'Notification Remainder',
      background: cardBackground,
      children: [
        _switchTile('Daily Devotion', _dailyDevotion, (v) => setState(() => _dailyDevotion = v)),
        _switchTile('Prayer Reminder', _prayerReminder, (v) => setState(() => _prayerReminder = v)),
        _switchTile('Community Updates', _communityUpdates, (v) => setState(() => _communityUpdates = v)),
        _switchTile('Compassion Messages', _compassionMessages, (v) => setState(() => _compassionMessages = v)),
        _switchTile('Night Briefings', _nightBriefing, (v) => setState(() => _nightBriefing = v)),
      ],
    );
  }

  Widget _buildPrivacySection() {
    return _SettingsCard(
      icon: Icons.lock_outline,
      title: 'Privacy Settings',
      background: cardBackground,
      children: [
        _switchTile('Profile Visible', _profileVisible, (v) => setState(() => _profileVisible = v),
            subtitle: 'Allow others to see your profile'),
        _switchTile('Share Grief Story', _shareStory, (v) => setState(() => _shareStory = v),
            subtitle: 'Share grief journey (anonymized)'),
        _switchTile('Allow Matching', _allowMatching, (v) => setState(() => _allowMatching = v),
            subtitle: 'Enable grief companion matching'),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _SettingsCard(
      icon: Icons.help_outline,
      title: 'Support & Help',
      background: cardBackground,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.book_outlined),
          title: Text('Grief Support Resources'),
          onTap: () {
            // TODO: Implement navigation to Grief Support Resources
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Grief Support Resources!')),
            );
          },
        ),
        Divider(height: 0),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.question_answer_outlined),
          title: Text('Help & FAQ'),
          onTap: () {
            // TODO: Implement navigation to Help & FAQ
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Help & FAQ!')),
            );
          },
        ),
        Divider(height: 0),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.policy_outlined),
          title: Text('Privacy Policy'),
          onTap: () {
            // TODO: Implement navigation to Privacy Policy
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Navigating to Privacy Policy!')),
            );
          },
        ),
      ],
    );
  }

  SwitchListTile _switchTile(String title, bool value, ValueChanged<bool> onChanged,
      {String? subtitle}) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle),
      value: value,
      activeColor: primaryOrange,
      onChanged: onChanged,
    );
  }
}

// ────────────────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.children,
    required this.background,
  });

  final IconData icon;
  final String title;
  final List<Widget> children;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.black87),
              const SizedBox(width: 4),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          ..._insertDividers(children),
        ],
      ),
    );
  }

  List<Widget> _insertDividers(List<Widget> list) {
    final result = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      result.add(list[i]);
      if (i != list.length - 1) result.add(const Divider(height: 0));
    }
    return result;
  }
}