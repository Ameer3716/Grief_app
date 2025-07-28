import 'package:flutter/material.dart';
import 'package:griefapp/screen/journal_entry_list_screen.dart';
import 'package:intl/intl.dart';

// --- Models for this screen ---
class VirtualCandle {
  final DateTime litDate;
  VirtualCandle() : litDate = DateTime.now();
}

class ImportantDate {
  final String title;
  final DateTime date;
  ImportantDate({required this.title, required this.date});
}

class RemembranceScreen extends StatefulWidget {
  const RemembranceScreen({Key? key}) : super(key: key);

  @override
  State<RemembranceScreen> createState() => _RemembranceScreenState();
}

class _RemembranceScreenState extends State<RemembranceScreen> {
  // In-memory state
  final List<VirtualCandle> _litCandles = [];
  final List<ImportantDate> _importantDates = [];
  final _dateTitleController = TextEditingController();

  void _lightCandle() {
    setState(() {
      _litCandles.add(VirtualCandle());
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('A candle has been lit in remembrance.')),
    );
  }

  void _addDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      // Show another dialog to get the title
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Add Milestone Title'),
                content: TextField(
                  controller: _dateTitleController,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'e.g., Birthday, Anniversary'),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      _dateTitleController.clear();
                      Navigator.of(ctx).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('Save'),
                    onPressed: () {
                      if (_dateTitleController.text.isNotEmpty) {
                        setState(() {
                          _importantDates.add(ImportantDate(title: _dateTitleController.text, date: pickedDate));
                          // Sort dates by upcoming
                          _importantDates.sort((a,b) => a.date.compareTo(b.date));
                        });
                        _dateTitleController.clear();
                        Navigator.of(ctx).pop();
                      }
                    },
                  ),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text(
          'Remembrance Hub',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- VIRTUAL CANDLES ---
            _Section(
              title: 'Virtual Candles',
              description: 'Light a virtual candle in memory of your loved one. This candle will remain lit on this page as a symbol of remembrance.',
              buttonLabel: 'Light a Candle',
              onPressed: _lightCandle,
            ),
            if (_litCandles.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Wrap(
                  spacing: 12.0,
                  runSpacing: 8.0,
                  children: _litCandles.map((_) => const Text('🕯️', style: TextStyle(fontSize: 32))).toList(),
                ),
              ),
            const SizedBox(height: 32),

            // --- IMPORTANT DATES ---
            _Section(
              title: 'Important Dates & Milestones',
              description: 'Add important dates like birthdays, anniversaries, or other significant milestones to remember and honor your loved one.',
              buttonLabel: 'Add Date',
              onPressed: _addDate,
            ),
            if (_importantDates.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: _importantDates.map((date) => ListTile(
                    leading: const Icon(Icons.calendar_today, color: Colors.orange),
                    title: Text(date.title),
                    trailing: Text(DateFormat.yMMMd().format(date.date)),
                  )).toList(),
                ),
              ),
            const SizedBox(height: 32),

            // --- LETTERS TO HEAVEN ---
            _Section(
              title: 'Letters to Heaven',
              description: 'Write letters to your loved one, sharing your thoughts, feelings, and memories. These letters will be kept private and can be revisited anytime.',
              buttonLabel: 'Write a Letter',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JournalEntryListScreen(journalType: 'Letters to Heaven')));
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  static const _orange = Color(0xFFDB7A1B);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.4),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: _orange,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              buttonLabel,
              style: theme.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}