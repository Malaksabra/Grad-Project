import 'package:flutter/material.dart';
import 'routine_model.dart';

class SelfRelianceActiveScreen extends StatefulWidget {
  final RoutineData routine;

  const SelfRelianceActiveScreen({
    super.key,
    required this.routine,
  });

  @override
  State<SelfRelianceActiveScreen> createState() => _SelfRelianceActiveScreenState();
}

class _SelfRelianceActiveScreenState extends State<SelfRelianceActiveScreen> {
  int currentStepIndex = 0;

  void _nextStep() {
    if (currentStepIndex < widget.routine.steps.length - 1) {
      setState(() {
        currentStepIndex++;
      });
    } else {
      // عند الوصول للخطوة الأخيرة وإنهاء النشاط
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('شاطر يا بطل! 🎉', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1B4D2E), fontWeight: FontWeight.bold)),
          content: Text('عملت نشاط ${widget.routine.title} بنفسك وبشكل ممتاز جداً!', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4D2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                ),
                onPressed: () {
                  Navigator.pop(context); // إغلاق الديالوج
                  Navigator.pop(context); // الرجوع للشاشة الرئيسية للأنشطة
                },
                child: const Text('حسناً', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    }
  }

  void _previousStep() {
    if (currentStepIndex > 0) {
      setState(() {
        currentStepIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = widget.routine.steps[currentStepIndex];
    final bool isLastStep = currentStepIndex == widget.routine.steps.length - 1;
    final bool isFirstStep = currentStepIndex == 0;

    // صياغة الجملة التشجيعية بذكاء حسب مكان الخطوة (أولى، في النص، أو أيرة)
    String encouragementText;
    if (isFirstStep) {
      encouragementText = 'يلا يا بطل! أول حاجة هنعملها: ${currentStep.title}';
    } else if (isLastStep) {
      encouragementText = 'برافو عليك! ودلوقتي آخر خطوة: ${currentStep.title}';
    } else {
      encouragementText = 'برافو! والخطوة اللي بعدها: ${currentStep.title}';
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // الشريط العلوي
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Center(
                      child: Text(
                        widget.routine.title,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2A44)),
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
                    // كارت الجملة التشجيعية المتغيرة بذكاء
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F6E8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF4CBB7F), width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF4CBB7F)),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              encouragementText,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E)),
                            ),
                          ),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFFFE0B2),
                            child: Text('🐻', style: TextStyle(fontSize: 22)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // مؤشر النقاط والخطوات العلوية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(widget.routine.steps.length, (index) {
                        bool isActive = index == currentStepIndex;
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: isActive ? const Color(0xFF1B4D2E) : const Color(0xFFDCE8F5),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),

                    // الكارت الرئيسي المعزز بـ صورة كبيرة وواضحة جداً للخطوة
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFFE0E0E0), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'خطوة ${currentStepIndex + 1} من ${widget.routine.steps.length}',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          const SizedBox(height: 16),

                          // عرض الصورة الكبيرة الواضحة أو الأيقونة المعبرة
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: currentStep.imagePath != null
                                ? Image.asset(
                              currentStep.imagePath!,
                              height: 220,
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Icon(
                                widget.routine.icon,
                                size: 140,
                                color: const Color(0xFF4CBB7F),
                              ),
                            )
                                : Icon(
                              currentStep.iconData ?? widget.routine.icon,
                              size: 140,
                              color: const Color(0xFF4CBB7F),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // اسم الخطوة بخط كبير وواضح
                          Text(
                            currentStep.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // أزرار التنقل بين الخطوات
                    Row(
                      children: [
                        if (currentStepIndex > 0) ...[
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF4CBB7F), width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: _previousStep,
                              child: const Text('السابقة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1B4D2E),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              elevation: 2,
                            ),
                            onPressed: _nextStep,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isLastStep ? 'خلصت كله!' : 'الخطوة اللي بعدها',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  isLastStep ? Icons.star_rounded : Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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