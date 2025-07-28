import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// --- Data Model ---
class ComfortMedia {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String audioUrl; // URL for the media file

  ComfortMedia({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.audioUrl,
  }) : id = UniqueKey().toString();
}

// --- Mock Data ---
final List<ComfortMedia> _meditations = [
  ComfortMedia(title: 'Meditation for Peace', subtitle: '10 min', icon: Icons.self_improvement, audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
  ComfortMedia(title: 'Finding Stillness in Grief', subtitle: '15 min', icon: Icons.self_improvement, audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3'),
];
final List<ComfortMedia> _playlists = [
  ComfortMedia(title: 'Hymns of Hope', subtitle: '45 min', icon: Icons.music_note, audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3'),
  ComfortMedia(title: 'Songs of Strength', subtitle: '60 min', icon: Icons.music_note, audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3'),
];
final List<ComfortMedia> _blessings = [
  ComfortMedia(title: 'Evening Prayer for Rest', subtitle: '5 min', icon: Icons.nightlight_round, audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-5.mp3'),
  ComfortMedia(title: 'A Blessing for a Peaceful Sleep', subtitle: '8 min', icon: Icons.nightlight_round, audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-6.mp3'),
];

class FaithfulComfortScreen extends StatefulWidget {
  const FaithfulComfortScreen({Key? key}) : super(key: key);

  @override
  State<FaithfulComfortScreen> createState() => _FaithfulComfortScreenState();
}

class _FaithfulComfortScreenState extends State<FaithfulComfortScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  PlayerState? _playerState;
  String? _currentlyPlayingId;

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _playerState = state;
          // If playback completes, reset the playing ID
          if (state == PlayerState.completed) {
            _currentlyPlayingId = null;
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _toggleAudio(ComfortMedia media) async {
    if (_currentlyPlayingId == media.id && _playerState == PlayerState.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.stop(); // Stop any previous track
      await _audioPlayer.play(UrlSource(media.audioUrl));
      setState(() {
        _currentlyPlayingId = media.id;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F6F6),
      appBar: AppBar(
        title: const Text('Faithful Comfort'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _SectionHeader(title: 'Guided Faith-based Meditations'),
          ..._meditations.map((item) => _buildComfortItem(item)).toList(),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Worship Playlists'),
          ..._playlists.map((item) => _buildComfortItem(item)).toList(),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Night Blessings'),
          ..._blessings.map((item) => _buildComfortItem(item)).toList(),
        ],
      ),
    );
  }

  Widget _buildComfortItem(ComfortMedia item) {
    final bool isPlaying = _currentlyPlayingId == item.id && _playerState == PlayerState.playing;
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: Icon(item.icon, color: Colors.black54),
        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(item.subtitle),
        trailing: Icon(
          isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
          color: const Color(0xFFDA7A25),
          size: 30,
        ),
        onTap: () => _toggleAudio(item),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}