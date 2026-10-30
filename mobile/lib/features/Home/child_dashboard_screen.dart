import 'package:flutter/material.dart';
// استيراد الشاشات الفعلية
import '../../features/daily_routines/routine_details_screen.dart';
import '../../features/daily_routines/self_reliance_categories_screen.dart';
import '../../features/social_situations/screens/social_situations_screen.dart';
import '../../features/stories/stories_texts.dart';

class ChildDashboardScreen extends StatefulWidget {
  const ChildDashboardScreen({super.key});

  @override
  State<ChildDashboardScreen> createState() => _ChildDashboardScreenState();
}

class _ChildDashboardScreenState extends State<ChildDashboardScreen> {
  int totalStars = 0; // إجمالي النجوم المكتسبة

  @override
  Widget build(BuildContext context) {
    // قائمة الأنشطة والدوائر البصرية للطفل (بما فيها دائرة الألعاب كشكل بصري شبه الإشارات)
    final List dashboardItems = [
      {
        'title': 'الروتين اليومي',
        'imagePath': 'assets/images/daily_routines/image3.png',
        'color': const Color(0xFF2E7D32),
        'gradient': [const Color(0xFFE8F8EE), const Color(0xFFC8E6C9)],
        'screen': const RoutineDetailsScreen(),
      },
      {
        'title': 'الاعتماد على النفس',
        'imagePath': 'assets/images/daily_routines/image4.jpg',
        'color': const Color(0xFF1565C0),
        'gradient': [const Color(0xFFEBF5FF), const Color(0xFFBBDEFB)],
        'screen': SelfRelianceCategoriesScreen(currentStars: totalStars),
      },
      {
        'title': 'الألعاب ', // دائرة الألعاب المضافة كشكل بصري شبه الإشارات
        'icon': Icons.sports_esports_rounded,
        'color': const Color(0xFF7C3AED),
        'gradient': [const Color(0xFFF3E8FF), const Color(0xFFDDD6FE)],
        // بدون شاشة انتقال حالياً (شبه الإشارات)
      },
      {
        'title': 'أقول نفسي في إيه؟',
        'icon': Icons.restaurant_menu_rounded,
        'color': const Color(0xFFE65100),
        'gradient': [const Color(0xFFFFF3E0), const Color(0xFFFFCC80)],
      },
      {
        'title': 'الإشارات ',
        'icon': Icons.waving_hand_rounded,
        'color': const Color(0xFF6A1B9A),
        'gradient': [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
      },
      {
        'title': StoriesTexts.sectionTitle,
        'icon': Icons.menu_book_rounded,
        'screen': SocialSituationsScreen(
          title: StoriesTexts.sectionTitle,
          onBack: () => Navigator.of(context).pop(),
        ),
        'color': const Color(0xFFC2185B),
        'gradient': [const Color(0xFFFCE4EC), const Color(0xFFF8BBD0)],
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEBF8FF), // خلفية سماوية فاتحة ومبهجة ومليئة بالحيوية
      body: Stack(
        children: [
          // 🎨 أشكال خلفية حيوية ومررحة تكسر الملل
          Positioned(
            top: -60,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFE082).withOpacity(0.35),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFF8A80).withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -50,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFCE93D8).withOpacity(0.25),
              ),
            ),
          ),

          // المحتوى الأساسي للصفحة داخل SafeArea
          SafeArea(
            child: Column(
              children: [
                // الشريط العلوي الفرفوش والمزخرف
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      const Text('✨', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'عالمي المرح 🎈🚀',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFFFD54F), width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFB300).withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Text(
                              '$totalStars',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3A8A),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB300),
                              size: 26,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFBAE6FD)),

                // المحتوى الرئيسي
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // كارت الروبوت الترحيبي الأنيق
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE0F2FE), Color(0xFFBAE6FD)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: const Color(0xFF0284C7), width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0284C7).withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Text('🤖', style: TextStyle(fontSize: 32)),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'أهلاً بك يا بطل المجد! 🌟',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF0369A1),
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'اختر دائرتك المفضلة لنبدأ اللعب والنشاط سوا!',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),

                        // شبكة الدوائر البصرية بالشكل الجديد والظل العالي (3D Effect)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 24,
                            childAspectRatio: 0.82,
                          ),
                          itemCount: dashboardItems.length,
                          itemBuilder: (context, index) {
                            final item = dashboardItems[index];
                            bool isImageCard = item['imagePath'] != null;

                            return GestureDetector(
                              onTap: item['screen'] != null
                                  ? () async {
                                final updatedStars = await Navigator.push<int>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => item['screen'],
                                  ),
                                );
                                if (updatedStars != null) {
                                  setState(() {
                                    totalStars = updatedStars;
                                  });
                                }
                              }
                                  : null, // لو مفيش شاشة زي الإشارات والألعاب حالياً، مش هتعمل أكشن
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // دائرة فخمة بظلال قوية تدي إيحاء بارز وجذاب جداً
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        border: Border.all(color: item['color'].withOpacity(0.5), width: 3),
                                        boxShadow: [
                                          BoxShadow(
                                            color: item['color'].withOpacity(0.3),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                          ),
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.05),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: item['gradient'],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 74,
                                            height: 74,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.08),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Center(
                                              child: isImageCard
                                                  ? ClipOval(
                                                child: Image.asset(
                                                  item['imagePath'],
                                                  width: 52,
                                                  height: 52,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Icon(
                                                      Icons.broken_image_rounded,
                                                      color: item['color'],
                                                      size: 32,
                                                    );
                                                  },
                                                ),
                                              )
                                                  : Icon(
                                                item['icon'],
                                                size: 38,
                                                color: item['color'],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  // اسم النشاط بخط فرفوش وبارز
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4),
                                    child: Text(
                                      item['title'],
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w900,
                                        color: item['color'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}