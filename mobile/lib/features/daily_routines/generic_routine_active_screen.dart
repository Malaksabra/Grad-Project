import 'dart:async';
import 'package:flutter/material.dart';
import 'routine_model.dart';

class GenericRoutineActiveScreen extends StatefulWidget {
  final RoutineData routine;
  final int currentStars;

  const GenericRoutineActiveScreen({
    super.key,
    required this.routine,
    required this.currentStars,
  });

  @override
  State<GenericRoutineActiveScreen> createState() => _GenericRoutineActiveScreenState();
}

class _GenericRoutineActiveScreenState extends State<GenericRoutineActiveScreen> {
  int currentStepIndex = 0;
  int remainingSeconds = 0;
  bool isPaused = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    remainingSeconds = widget.routine.steps[currentStepIndex].seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        setState(() {
          if (remainingSeconds > 0) {
            remainingSeconds--;
          } else {
            _nextStep();
          }
        });
      }
    });
  }

  void _nextStep() {
    // التحقق هل لسه فيه خطوات تالية ولا دي كانت الخطوة الأخيرة
    if (currentStepIndex < widget.routine.steps.length - 1) {
      setState(() {
        currentStepIndex++;
        _startTimer();
      });
    } else {
      // لو دي الخطوة الأخيرة ووقتها خلص، نوقف التايمر ونعرض ديالوج النجاح
      _timer?.cancel();
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('برافو عليك! 🎉', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF1B4D2E), fontWeight: FontWeight.bold)),
          content: Text('خلصت روتين ${widget.routine.title} براحتك وبنجاح يا بطل!', textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B4D2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                onPressed: () {
                  Navigator.pop(context); // إغلاق الديالوج
                  Navigator.pop(context, true); // العودة للقائمة والشاشة الرئيسية وإعطاء علامة صح
                },
                child: const Text('حسناً', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final currentStep = widget.routine.steps[currentStepIndex];
    // تحديد الخطوة التالية لعرضها في الشاشة (لو مش الأخيرة)
    final bool isLastStep = currentStepIndex == widget.routine.steps.length - 1;
    final nextStepTitle = !isLastStep ? widget.routine.steps[currentStepIndex + 1].title : 'النشاط التالي';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
                    child: Row(
                      children: [
                        Text('${widget.currentStars}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 6),
                        const Icon(Icons.star_rounded, color: Color(0xFFF5B82E), size: 24),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        isLastStep ? 'الخطوة الأخيرة' : 'الصبح',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A44)),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF1E2A44)),
                    onPressed: () => Navigator.pop(context, false),
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
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF4CBB7F), width: 2),
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Color(0xFFE3F6E8), shape: BoxShape.circle),
                            child: IconButton(icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF4CBB7F)), onPressed: () {}),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'ده جدول الصبح. هنعمل كل حاجة بالترتيب وبهدوء.',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E)),
                            ),
                          ),
                          const CircleAvatar(backgroundColor: Color(0xFFFFE0B2), child: Text('🐻', style: TextStyle(fontSize: 20))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2F9F4),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFF4CBB7F), width: 2),
                      ),
                      child: Column(
                        children: [
                          // شريط الدوائر العلوية لجميع الخطوات (بما فيها الأخيرة)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(widget.routine.steps.length, (index) {
                              bool isActive = index == currentStepIndex;
                              final step = widget.routine.steps[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: isActive ? const Color(0xFF1B4D2E) : Colors.transparent, width: 2),
                                ),
                                child: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white,
                                  child: step.imagePath != null
                                      ? Image.asset(step.imagePath!, width: 18, height: 18, errorBuilder: (_, __, ___) => Icon(widget.routine.icon, size: 14))
                                      : Icon(step.iconData ?? widget.routine.icon, size: 14, color: const Color(0xFF4CBB7F)),
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 16),

                          // بطاقة عرض تفاصيل الخطوة الحالية (صورة واسم الخطوة والخطوة اللي بعدها)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
                            ),
                            child: Column(
                              children: [
                                Text('خطوة ${currentStepIndex + 1} من ${widget.routine.steps.length}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                const SizedBox(height: 12),
                                currentStep.imagePath != null
                                    ? Image.asset(currentStep.imagePath!, width: 85, height: 85, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(widget.routine.icon, size: 60, color: const Color(0xFF4CBB7F)))
                                    : Icon(currentStep.iconData ?? widget.routine.icon, size: 60, color: const Color(0xFF4CBB7F)),
                                const SizedBox(height: 14),
                                Text(currentStep.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                const SizedBox(height: 8),
                                Text(isLastStep ? 'دي آخر خطوة، برافو!' : 'بعدها: $nextStepTitle', style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // دائرة العد التنازلي للوقت (تعمل الآن لكل الخطوات بما فيها الأخيرة بكل إتقان)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
                            ),
                            child: Column(
                              children: [
                                const Text('الوقت', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                const SizedBox(height: 16),
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      height: 130,
                                      child: CircularProgressIndicator(
                                        value: remainingSeconds / currentStep.seconds,
                                        strokeWidth: 10,
                                        backgroundColor: const Color(0xFFE8F5E9),
                                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CBB7F)),
                                      ),
                                    ),
                                    Text(_formatTime(remainingSeconds), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // أزرار التحكم (إيقاف مؤقت، تم إنجاز الخطوة، وزيادة الوقت)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () => setState(() => isPaused = !isPaused),
                                child: Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF4CBB7F), width: 2)),
                                  child: Icon(isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded, color: const Color(0xFF1B4D2E), size: 28),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B4D2E),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                  ),
                                  onPressed: _nextStep,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(isLastStep ? 'خلصت!' : 'عملتها', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                      const SizedBox(width: 8),
                                      const Icon(Icons.check_rounded, color: Colors.white, size: 24),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF4CBB7F), width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () => setState(() => remainingSeconds += 15),
                              child: const Text('+ 15 ثانية', style: TextStyle(color: Color(0xFF1B4D2E), fontSize: 16, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFF4CBB7F), width: 2),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                backgroundColor: Colors.white,
                              ),
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('كل الخطوات', style: TextStyle(color: Color(0xFF1B4D2E), fontSize: 16, fontWeight: FontWeight.bold)),
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