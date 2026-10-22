import 'package:flutter/material.dart';
import 'routine_details_screen.dart'; // استيراد صفحة تفاصيل الروتين
import 'self_reliance_categories_screen.dart'; // استيراد صفحة أنشطة أعتمد على نفسي

class DailyRoutinesScreen extends StatelessWidget {
  const DailyRoutinesScreen({super.key});

  // الألوان الأساسية
  static const Color cardColor = Color(0xFFE3F6E8);
  static const Color edgeColor = Color(0xFF4CBB7F);
  static const Color textColor = Color(0xFF1B4D2E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(stars: 0),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const _HeaderCard(done: 0, total: 2),
                    const SizedBox(height: 24),
                    // استخدام IntrinsicHeight لضمان تساوي ارتفاع الكارتين بجانب بعضهما تماماً
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // الكارت الأول: الروتين اليومي (ينقل لصفحة تفاصيل الروتين)
                          Expanded(
                            child: _RoutineCard(
                              title: 'الروتين اليومي',
                              imagePath: 'assets/images/daily_routines/image3.png',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RoutineDetailsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // الكارت الثاني: الاعتماد على النفس (ينقل لصفحة اختيار الأنشطة الحرة)
                          Expanded(
                            child: _RoutineCard(
                              title: 'الاعتماد على النفس',
                              imagePath: 'assets/images/daily_routines/image4.jpg',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SelfRelianceCategoriesScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int stars;
  const _TopBar({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFDCE8F5), width: 2),
            ),
            child: Row(
              children: [
                Text(
                  '$stars',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.star_border_rounded,
                    color: Color(0xFFF5B82E), size: 24),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'الروتين اليومي',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E2A44),
                ),
              ),
            ),
          ),
          const SizedBox(width: 70),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final int done;
  final int total;
  const _HeaderCard({required this.done, required this.total});

  @override
  Widget build(BuildContext context) {
    return _GreenCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: Icon(Icons.calendar_month_rounded,
                  size: 32, color: Color(0xFF6C7BD9)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الروتين اليومي',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: DailyRoutinesScreen.textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'أنجزت $done من أصل $total',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: DailyRoutinesScreen.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onTap;

  const _RoutineCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _GreenCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: Image.asset(
                    imagePath,
                    width: 50,
                    height: 50,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: DailyRoutinesScreen.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GreenCard extends StatelessWidget {
  final Widget child;
  const _GreenCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: DailyRoutinesScreen.edgeColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: DailyRoutinesScreen.cardColor,
          borderRadius: BorderRadius.circular(28),
        ),
        child: child,
      ),
    );
  }
}