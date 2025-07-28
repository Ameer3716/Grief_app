// lib/screen/new_journal_entry_screen.dart
import 'package:flutter/material.dart';
import 'package:griefapp/data/mock_data.dart';

class NewJournalEntryScreen extends StatefulWidget {
  final String journalType;
  const NewJournalEntryScreen({Key? key, required this.journalType}) : super(key: key);

  @override
  State<NewJournalEntryScreen> createState() => _NewJournalEntryScreenState();
}

class _NewJournalEntryScreenState extends State<NewJournalEntryScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final JournalData _journalData = JournalData();

  void _saveEntry() {
    if (_formKey.currentState!.validate()) {
      final newEntry = JournalEntry(
        title: _titleController.text,
        content: _contentController.text,
        date: DateTime.now(),
      );
      _journalData.addEntry(widget.journalType, newEntry);
      Navigator.of(context).pop(true); // Pop with a result to indicate success
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New ${widget.journalType} Entry'),
        backgroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: _saveEntry,
            child: const Text('Save', style: TextStyle(color: Colors.orange, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Your thoughts...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 15,
                validator: (value) => value == null || value.isEmpty ? 'Please enter some content' : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}