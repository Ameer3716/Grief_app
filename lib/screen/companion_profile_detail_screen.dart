// lib/screen/companion_profile_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:griefapp/data/mock_data.dart';

class CompanionProfileDetailScreen extends StatelessWidget {
  final GriefCompanionProfile profile;

  const CompanionProfileDetailScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(profile.name),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                profile.avatarUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 150, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoChip('${profile.griefStage} | ${profile.griefType}'),
                  const SizedBox(height: 24),
                  const Text(
                    'About Me',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profile.bio,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                       // This would integrate with the actual connection logic
                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(content: Text('Connection request sent to ${profile.name}!')
                       ),
                      );
                    },
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Send Connection Request'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.orange.shade100,
      labelStyle: TextStyle(color: Colors.orange.shade900),
    );
  }
}