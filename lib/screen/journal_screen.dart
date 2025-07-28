import 'package:flutter/material.dart';
import 'package:griefapp/screen/journal_entry_list_screen.dart'; // Import the new screen
import 'package:griefapp/screen/new_journal_entry_screen.dart'; // Import the new screen

class JournalScreen extends StatelessWidget {
  const JournalScreen({Key? key}) : super(key: key);

  void _showNewEntryDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.edit_note),
            title: const Text('New Prayer'),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NewJournalEntryScreen(journalType: 'Prayers')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: const Text('New Letter'),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NewJournalEntryScreen(journalType: 'Letters')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.sentiment_satisfied_alt),
            title: const Text('New Gratitude Entry'),
            onTap: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const NewJournalEntryScreen(journalType: 'Gratitude')));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton( // Added back button for better navigation
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Journal',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black, size: 22),
            onPressed: () => _showNewEntryDialog(context),
            tooltip: 'New entry',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: const [
          _Section(
            label: 'Prayers',
            assetPath: 'assets/images/prayers.jpg',
            fallbackUrl: 'https://images.unsplash.com/photo-1496307042754-b4aa456c4a2d',
          ),
          SizedBox(height: 28),
          _Section(
            label: 'Letters',
            assetPath: 'assets/images/letters.jpg',
            fallbackUrl: 'https://images.unsplash.com/photo-1529333166437-7750a6dd5a70',
          ),
          SizedBox(height: 28),
          _Section(
            label: 'Gratitude',
            assetPath: 'assets/images/gratitude.jpg',
            fallbackUrl: 'https://images.unsplash.com/photo-1514846326719-9086d4c7883b',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String label;
  final String assetPath;
  final String fallbackUrl;

  const _Section({
    Key? key,
    required this.label,
    required this.assetPath,
    required this.fallbackUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            // Navigate to the specific journal list screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => JournalEntryListScreen(journalType: label),
              ),
            );
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: _ImageWithFallback(
                assetPath: assetPath,
                fallbackUrl: fallbackUrl,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ImageWithFallback extends StatelessWidget {
  final String assetPath;
  final String fallbackUrl;

  const _ImageWithFallback({
    Key? key,
    required this.assetPath,
    required this.fallbackUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Image.network(
        fallbackUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) => progress == null
            ? child
            : Container(
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
      ),
    );
  }
}