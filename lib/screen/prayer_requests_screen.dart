import 'package:flutter/material.dart';

// Model class with a mutable count
class PrayerRequest {
  final String name;
  final int daysAgo;
  final String message;
  int count; // Changed to be mutable
  final String avatarUrl;

  PrayerRequest({
    required this.name,
    required this.daysAgo,
    required this.message,
    required this.count,
    required this.avatarUrl,
  });
}

// Dummy data list
final List<PrayerRequest> _dummyRequests = [
  PrayerRequest(
    name: 'Sarah M.',
    daysAgo: 2,
    count: 12,
    message: 'Please pray for my family as we navigate this difficult time. We need strength and guidance.',
    avatarUrl: 'https://i.pravatar.cc/100?img=47',
  ),
  PrayerRequest(
    name: 'David L.',
    daysAgo: 3,
    count: 25,
    message: 'Pray for my friend, Mark, who is battling a serious illness. We need a miracle.',
    avatarUrl: 'https://i.pravatar.cc/100?img=12',
  ),
  PrayerRequest(
    name: 'Karen S.',
    daysAgo: 4,
    count: 18,
    message: 'Please pray for my daughter, Emily, who is struggling with anxiety and depression. We need peace and healing.',
    avatarUrl: 'https://i.pravatar.cc/100?img=32',
  ),
];

class PrayerRequestsScreen extends StatefulWidget {
  const PrayerRequestsScreen({Key? key}) : super(key: key);

  @override
  State<PrayerRequestsScreen> createState() => _PrayerRequestsScreenState();
}

class _PrayerRequestsScreenState extends State<PrayerRequestsScreen> {
  static const _orange = Color(0xFFDA7A25);
  final _prayerController = TextEditingController();
  
  // Local state to manage the list of requests
  late final List<PrayerRequest> _requests;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the dummy data
    _requests = _dummyRequests.map((e) => PrayerRequest(name: e.name, daysAgo: e.daysAgo, message: e.message, count: e.count, avatarUrl: e.avatarUrl)).toList();
  }

  void _incrementPrayer(PrayerRequest request) {
    setState(() {
      request.count++;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You prayed for ${request.name}.')),
    );
  }

  void _submitPrayer() {
    if (_prayerController.text.trim().isEmpty) return;

    final newRequest = PrayerRequest(
        name: 'You', // Or a logged-in user's name
        daysAgo: 0,
        message: _prayerController.text.trim(),
        count: 0,
        avatarUrl: 'https://i.pravatar.cc/100?img=1'); // Placeholder avatar
    
    setState(() {
      _requests.insert(0, newRequest);
      _prayerController.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your prayer has been shared.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        centerTitle: true,
        title: const Text(
          'Community Prayer Wall',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          // ─── Share a Prayer Request ────────────────────────────────────────
          const Text(
            'Share a Prayer Request',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _prayerController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Share what\'s on your heart...',
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
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
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              ),
              onPressed: _submitPrayer,
              child: const Text(
                'Submit',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 28),
          // ─── Prayer Requests List ───────────────────────────────────────────
          const Text(
            'Prayer Requests',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ..._requests.map((req) => _RequestCard(
            data: req,
            onPrayed: () => _incrementPrayer(req),
          )).toList(),
        ],
      ),
    );
  }
}

class _RequestCard extends StatelessWidget {
  final PrayerRequest data;
  final VoidCallback onPrayed;

  const _RequestCard({required this.data, required this.onPrayed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundImage: NetworkImage(data.avatarUrl),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  data.daysAgo == 0 ? 'Posted just now' : 'Posted ${data.daysAgo} days ago',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  data.message,
                  style: const TextStyle(height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onPrayed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                children: [
                  const Text('🙏', style: TextStyle(fontSize: 20)),
                  const SizedBox(height: 4),
                  Text(
                    data.count.toString(),
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}