// lib/screen/journal_entry_list_screen.dart
import 'package:flutter/material.dart';
import 'package:griefapp/data/mock_data.dart';
import 'package:griefapp/screen/new_journal_entry_screen.dart';
import 'package:intl/intl.dart';

class JournalEntryListScreen extends StatefulWidget {
  final String journalType;

  const JournalEntryListScreen({Key? key, required this.journalType}) : super(key: key);

  @override
  State<JournalEntryListScreen> createState() => _JournalEntryListScreenState();
}

class _JournalEntryListScreenState extends State<JournalEntryListScreen> {
  final JournalData _journalData = JournalData();

  void _addEntry() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NewJournalEntryScreen(journalType: widget.journalType),
      ),
    );

    if (result == true) {
      setState(() {
        // Data has been added, just rebuild the screen
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final entries = _journalData.entries[widget.journalType] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journalType),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: entries.isEmpty
          ? Center(
              child: Text(
                'No entries yet.\nTap the + button to add one.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  child: ListTile(
                    title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      entry.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Text(
                      DateFormat.yMMMd().format(entry.date),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      // TODO: Implement viewing a full entry in a detail screen
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text(entry.title),
                          content: SingleChildScrollView(child: Text(entry.content)),
                          actions: [
                            TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close'))
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
    );
  }
}