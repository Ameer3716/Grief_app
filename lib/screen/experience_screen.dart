import 'package:flutter/material.dart';
import 'package:griefapp/screen/signup_screen.dart';

class ExperienceScreen extends StatefulWidget {
  const ExperienceScreen({Key? key}) : super(key: key);

  @override
  State<ExperienceScreen> createState() => _ExperienceScreenState();
}

class _ExperienceScreenState extends State<ExperienceScreen> {
  /* palette —— identical to welcome screen */
  static const _orange = Color(0xFFD97706);
  static const _beige  = Color(0xFFF2D4B6);

  final List<String> _experiences = [
    'Loss of a loved one',
    'Health challenge',
    'Career setback',
    'Relationship issue',
    'Other' // Added 'Other' for broader matching
  ];
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;           // device width / height

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /* ─── background hero (same photo, 25 % zoom) ─── */
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, -90),           // move up a little
                child: Transform.scale(
                  scale: 1.25,
                  child: Image.asset(
                    'assets/images/meditation.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            /* overlay for legibility */
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.25),
                      Colors.transparent,
                      Colors.black.withOpacity(.20),
                    ],
                    stops: const [0.0, .55, 1.0],
                  ),
                ),
              ),
            ),

            /* SOULNEST title */
            Positioned(
              top: size.height * 0.18,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const Text(
                    'SOULNEST',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: _orange,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 70,
                    height: 4,
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            /* ─── translucent beige card ─── */
            Positioned(
              top: size.height * 0.30,
              left: 32,
              right: 32,
              child: Container(
                decoration: BoxDecoration(
                  color: _beige.withOpacity(.60),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      /* ↓ smaller main heading */
                      Text(
                        'Share your Journey',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,        // ← was default (~22–24)
                        ),
                      ),
                      const SizedBox(height: 22),

                      /* ↓ smaller sub-heading */
                      Text(
                        'Your Current Experience',
                        textAlign: TextAlign.center,          // ← add this line
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /* orange pill dropdown */
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: _orange,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              dropdownColor: _orange.withOpacity(.92),
                              value: _selected,
                              isExpanded: true,
                              iconEnabledColor: Colors.white,
                              iconSize: 24,
                              hint: const Text(
                                'Choose what describes you...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                                softWrap: false,
                              ),
                              items: _experiences
                                  .map(
                                    (e) => DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(
                                    e,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                                  .toList(),
                              onChanged: (val) => setState(() => _selected = val),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /* help text */
                      Text(
                        'This helps us connect others who understand your path and provide relevant spiritual support',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontSize: 12, height: 1.4),
                      ),
                      const SizedBox(height: 28),

                      /* continue button */
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          minimumSize: const Size.fromHeight(48),
                        ),
                        onPressed: _selected == null
                            ? null
                            : () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        ),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}