import 'package:flutter/material.dart';

import '../../shared/widgets/section_top_bar.dart';
import '../Home/home_progress.dart';
import 'routine_details_screen.dart'; // استيراد صفحة تفاصيل الروتين
import 'self_reliance_categories_screen.dart'; // استيراد صفحة أنشطة أعتمد على نفسي

class DailyRoutinesScreen extends StatefulWidget {
  const DailyRoutinesScreen({super.key, required this.onBack});

  /// بيرجّع المستخدم لتاب الرئيسية (بييجي من AppShell).
  final VoidCallback onBack;

  @override
  State<DailyRoutinesScreen> createState() => _DailyRoutinesScreenState();
}

class _DailyRoutinesScreenState extends State<DailyRoutinesScreen> {
  // الألوان الأساسية
  static const Color cardColor = Color(0xFFE3F6E8);
  static const Color edgeColor = Color(0xFF4CBB7F);
  static const Color textColor = Color(0xFF1B4D2E);

  /// النجوم دلوقتي مصدرها واحد: HomeProgress، فبتظهر في كل الأقسام.
  void _syncStars(int? updatedStars) {
    if (updatedStars == null) return;
    final delta = updatedStars - HomeProgress.instance.stars;
    if (delta > 0) HomeProgress.instance.addStars(delta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // شريط علوي مشترك: زر الرجوع للرئيسية + النجوم
            SectionTopBar(onBack: widget.onBack, title: 'الروتين اليومي'),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const _HeaderCard(done: 0, total: 2),
                    const SizedBox(height: 24),
                    // IntrinsicHeight لضمان تساوي ارتفاع الكارتين
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: _RoutineCard(
                              title: 'الروتين اليومي',
                              imagePath:
                                  'assets/images/daily_routines/image3.png',
                              onTap: () async {
                                final updatedStars =
                                    await Navigator.push<int>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const RoutineDetailsScreen(),
                                  ),
                                );
                                _syncStars(updatedStars);
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _RoutineCard(
                              title: 'الاعتماد على النفس',
                              imagePath:
                                  'assets/images/daily_routines/image4.jpg',
                              onTap: () async {
                                final updatedStars =
                                    await Navigator.push<int>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SelfRelianceCategoriesScreen(
                                      currentStars:
                                          HomeProgress.instance.stars,
                                    ),
                                  ),
                                );
                                _syncStars(updatedStars);
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
                      color: Color(0xFF1B4D2E),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'أنجزت $done من أصل $total',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1B4D2E),
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
                  color: Color(0xFF1B4D2E),
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
        color: const Color(0xFF4CBB7F),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F6E8),
          borderRadius: BorderRadius.circular(28),
        ),
        child: child,
      ),
    );
  }
}