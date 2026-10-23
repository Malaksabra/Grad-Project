import 'package:flutter/material.dart';
import 'routine_details_screen.dart'; // استيراد صفحة تفاصيل الروتين
import 'self_reliance_categories_screen.dart'; // استيراد صفحة أنشطة أعتمد على نفسي

class DailyRoutinesScreen extends StatefulWidget {
  const DailyRoutinesScreen({super.key});

  @override
  State<DailyRoutinesScreen> createState() => _DailyRoutinesScreenState();
}

class _DailyRoutinesScreenState extends State<DailyRoutinesScreen> {
  // متغير لتخزين وتراكم عدد النجوم في التطبيق وتحديثها فورياً
  int totalStars = 0;

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
            // تمرير إجمالي النجوم للشريط العلوي مع عكس الأيقونة لتكون صفراء ممتلئة عند وجود نجوم
            _TopBar(stars: totalStars),
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
                          // الكارت الأول: الروتين اليومي (ينقل لصفحة تفاصيل الروتين ويستقبل النجوم)
                          Expanded(
                            child: _RoutineCard(
                              title: 'الروتين اليومي',
                              imagePath: 'assets/images/daily_routines/image3.png',
                              onTap: () async {
                                final updatedStars = await Navigator.push<int>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RoutineDetailsScreen(),
                                  ),
                                );
                                if (updatedStars != null) {
                                  setState(() {
                                    totalStars = updatedStars;
                                  });
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          // الكارت الثاني: الاعتماد على النفس (ينقل لصفحة الأنشطة ويستقبل النجوم)
                          Expanded(
                            child: _RoutineCard(
                              title: 'الاعتماد على النفس',
                              imagePath: 'assets/images/daily_routines/image4.jpg',
                              onTap: () async {
                                final updatedStars = await Navigator.push<int>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelfRelianceCategoriesScreen(currentStars: totalStars),
                                  ),
                                );
                                if (updatedStars != null) {
                                  setState(() {
                                    totalStars = updatedStars;
                                  });
                                }
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
                // النجمة تصبح صفراء ممتلئة طالما عدد النجوم أكبر من الصفر
                Icon(
                  stars > 0 ? Icons.star_rounded : Icons.star_border_rounded,
                  color: const Color(0xFFF5B82E),
                  size: 24,
                ),
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