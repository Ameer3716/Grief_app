import 'package:flutter/material.dart';
import 'package:griefapp/screen/daily_devotion_screen.dart';

/* ─── shared palette ─── */
const _orange = Color(0xFFD97706);
const _beige  = Color(0xFFF2D4B6);

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameCtrl = TextEditingController();
  final _mailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _mailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /* ── hero (zoom-in + slight upward shift) ── */
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, -95), // was –80 → less empty space below
                child: Transform.scale(
                  scale: 1.25,
                  child: Image.asset(
                    'assets/images/meditation.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            /* ── overlay ── */
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.25),
                      Colors.transparent,
                      Colors.black.withOpacity(.22),
                    ],
                    stops: const [0.0, .55, 1.0],
                  ),
                ),
              ),
            ),

            /* ── SOULNEST ── */
            Positioned(
              top: size.height * 0.17, // a hair higher than before
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
                    width: 70,
                    height: 4,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                      color: _orange,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),

            /* ── sign-up card ── */
            Positioned(
              top: size.height * 0.28, // was 0.30 → card slides up ~15-20 px
              left: 32,
              right: 32,
              child: _SignupCard(
                nameCtrl: _nameCtrl,
                mailCtrl: _mailCtrl,
                passCtrl: _passCtrl,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────────── card widget ───────────────────────────── */
class _SignupCard extends StatelessWidget {
  const _SignupCard({
    required this.nameCtrl,
    required this.mailCtrl,
    required this.passCtrl,
  });

  final TextEditingController nameCtrl;
  final TextEditingController mailCtrl;
  final TextEditingController passCtrl;

  @override
  Widget build(BuildContext context) {
    /* pill-style InputDecoration (unchanged) */
    InputDecoration _pill(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white, fontSize: 13),
      filled: true,
      fillColor: _orange,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: _beige.withOpacity(.60),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /* smaller headline */
            Text(
              'Create Your  Account',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18, // ← smaller
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),

            _label('Full Name'),
            TextField(controller: nameCtrl, decoration: _pill('Enter your name')),
            const SizedBox(height: 12),

            _label('Email'),
            TextField(controller: mailCtrl, decoration: _pill('Enter your email')),
            const SizedBox(height: 12),

            _label('Password'),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: _pill('Enter your password'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DailyDevotionScreen()),
                );
              },
              child: const Text(
                'Enter Your Sanctuary',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /* label helper (smaller font) */
  Widget _label(String txt) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      txt,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
    ),
  );
}