import 'package:flutter/material.dart';
import 'routine_model.dart';
import 'self_reliance_active_screen.dart';

class SelfRelianceCategoriesScreen extends StatelessWidget {
  const SelfRelianceCategoriesScreen({super.key});

  // الألوان الأساسية المطابقة للتصميم الشيك
  static const Color mintContainerColor = Color(0xFFE3F6E8); // لون الكارد الأم المينت
  static const Color mintBorderColor = Color(0xFF4CBB7F);    // لون الإطار الأخضر
  static const Color darkTextColor = Color(0xFF1B4D2E);       // لون النصوص الداكنة

  // دالة لاختيار الصورة الأوضح والأكثر واقعية لكل نشاط في الكروت الرئيسية
  String? getBestRoutineImage(String routineId) {
    switch (routineId) {
      case 'bed':
        return 'assets/images/daily_routines/image6.png'; // ترتيب السرير
      case 'bathroom':
        return 'assets/images/daily_routines/image9.png'; // قاعد على التواليت (واقعي ومعبر)
      case 'clothes':
        return 'assets/images/daily_routines/image14.png'; // اختيار الملابس
      case 'breakfast':
        return 'assets/images/daily_routines/image21.png'; // الأكل قدامه وبيفطر (واقعي ومعبر)
      case 'teeth':
        return 'assets/images/daily_routines/image32.png'; // تنظيف الأسنان
      case 'bag':
        return 'assets/images/daily_routines/image38.png'; // تجهيز الشنطة
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // الخلفية البيضاء الشيك
      body: SafeArea(
        child: Column(
          children: [
            // الشريط العلوي (العنوان والنجوم وزر الرجوع)
            Padding(
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
                    child: const Row(
                      children: [
                        Text('0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Icon(Icons.star_border_rounded, color: Color(0xFFF5B82E), size: 24),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'أعتمد على نفسي',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E2A44),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF1E2A44)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // كارت توجيه الدب المريح
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: mintBorderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: mintContainerColor, shape: BoxShape.circle),
                            child: IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: mintBorderColor),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'يلا نختار حاجة نعملها خطوة بخطوة لوحدنا.',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: darkTextColor,
                              ),
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFFFE0B2),
                            child: Text('🐻', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // الكارد الأم المينت جرين الذي يضم شبكة الكروت البيضاء
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: mintContainerColor,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: mintBorderColor, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16, right: 4),
                            child: Text(
                              'نعمل إيه؟',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: darkTextColor,
                              ),
                            ),
                          ),
                          // شبكة الكروت البيضاء الصغيرة
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.92,
                            ),
                            itemCount: morningRoutinesData.length,
                            itemBuilder: (context, index) {
                              final routine = morningRoutinesData[index];
                              // استدعاء الصورة الواقعية المخصصة لكل نشاط
                              final String? cardImage = getBestRoutineImage(routine.id);

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SelfRelianceActiveScreen(routine: routine),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white, // الكارد الصغير باللون الأبيض
                                    borderRadius: BorderRadius.circular(22),
                                    border: Border.all(color: const Color(0xFFD0E8D7), width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // عرض الصورة الواقعية المعبرة بحجم ممتاز داخل الكارد
                                      Expanded(
                                        child: cardImage != null
                                            ? Image.asset(
                                          cardImage,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) => Icon(
                                            routine.icon,
                                            size: 50,
                                            color: mintBorderColor,
                                          ),
                                        )
                                            : Icon(
                                          routine.icon,
                                          size: 50,
                                          color: mintBorderColor,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      // اسم النشاط
                                      Text(
                                        routine.title,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: darkTextColor,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // عدد الخطوات فقط
                                      Text(
                                        '${routine.steps.length} خطوات',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
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