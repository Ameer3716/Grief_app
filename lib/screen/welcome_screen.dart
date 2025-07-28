import 'package:flutter/material.dart';
import 'package:griefapp/screen/experience_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  /* palette */
  static const _orange = Color(0xFFD97706);
  static const _beige  = Color(0xFFF2D4B6);

  /* helper for the three avatars */
  Widget _avatar(String path, {double r = 28}) => ClipOval(
    child: Image.asset(
      path,
      width: r * 2,
      height: r * 2,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => CircleAvatar(
        radius: r,
        backgroundColor: Colors.grey.shade400,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /* ─── full-screen background ─── */
            /* ─── full-screen background (zoomed 15 %) ─── */
            Positioned.fill(
              child: Transform.scale(                     // <-- NEW
                scale: 1.15,                              // 1.00 = original, 1.15 = 15 % zoom
                child: Image.asset(
                  'assets/images/meditation.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            /* subtle dark-to-light overlay for legibility */
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
                    stops: const [0.0, 0.55, 1.0],
                  ),
                ),
              ),
            ),

            /* ─── avatars row ─── */
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: SizedBox(
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /* side avatars lower (offset 30) */
                    Positioned(left: 0,  top: 44, child: _avatar('assets/images/1.jpg')),
                    Positioned(right: 0, top: 44, child: _avatar('assets/images/3.jpg')),
                    /* centre avatar slightly lower than top edge */
                    Positioned(top: 12, child: _avatar('assets/images/2.jpg', r: 34)),
                  ],
                ),
              ),
            ),

            /* ─── SOULNEST title (bright face area) ─── */
            Positioned(
              top: size.height * 0.34,   // adjust if you swap illustration
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Text(
                    'SOULNEST',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
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

            /* ─── beige info card (begins at shoulders) ─── */
            Positioned(
              top: size.height * 0.46,   // was 0.42  → starts lower (below shoulders)
              left: 32,                  // was 16   → card narrower
              right: 32,                 // was 16
              child: Container(
                decoration: BoxDecoration(
                  color: _beige.withOpacity(.58),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 13),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '“Blessed Are Those Who Mourn, For They Will Be Comforted.”',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        '- Matthew 5:4',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'welcome to the sacred space of healing,\n'
                            'you are not alone in your journey of grief\n'
                            'and remembrance',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, height: 1.35),
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _orange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ExperienceScreen(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Begin  Your Journey',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward,
                                  size: 18, color: Colors.white),
                            ],
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