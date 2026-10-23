import 'package:flutter/material.dart';
import 'routine_model.dart';
import 'generic_routine_active_screen.dart';

class GenericRoutineListScreen extends StatelessWidget {
  final RoutineData routine;
  final int currentStars;

  const GenericRoutineListScreen({
    super.key,
    required this.routine,
    required this.currentStars,
  });

  @override
  Widget build(BuildContext context) {
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
                        Text('$currentStars', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 6),
                        const Icon(Icons.star_rounded, color: Color(0xFFF5B82E), size: 24),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text('الصبح', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E2A44))),
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
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Color(0xFFE3F6E8), shape: BoxShape.circle),
                            child: IconButton(icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF4CBB7F)), onPressed: () {}),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text('ده جدول الصبح. هنعمل كل حاجة بالترتيب وبهدوء.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                          ),
                          const CircleAvatar(backgroundColor: Color(0xFFFFE0B2), child: Text('🐻', style: TextStyle(fontSize: 20))),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3F6E8),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: const Color(0xFF4CBB7F), width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('خطوات: ${routine.title}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                                child: Text('الوقت كله ${routine.totalTimeString}', style: const TextStyle(fontSize: 12, color: Color(0xFF1B4D2E), fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...List.generate(routine.steps.length, (index) {
                            final step = routine.steps[index];
                            int minutes = step.seconds ~/ 60;
                            int secs = step.seconds % 60;
                            String timeFormatted = '$minutes:${secs.toString().padLeft(2, '0')}';

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 3))],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(timeFormatted, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(step.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                  ),
                                  Row(
                                    children: [
                                      step.imagePath != null
                                          ? Image.asset(step.imagePath!, width: 34, height: 34, fit: BoxFit.contain, errorBuilder: (_, __, ___) => Icon(routine.icon, color: const Color(0xFF4CBB7F)))
                                          : Icon(step.iconData ?? routine.icon, color: const Color(0xFF4CBB7F), size: 34),
                                      const SizedBox(width: 8),
                                      CircleAvatar(
                                        radius: 14,
                                        backgroundColor: const Color(0xFFE3F6E8),
                                        child: Text('${index + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF4CBB7F), width: 2),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                    backgroundColor: Colors.white,
                                  ),
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('رجوع', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1B4D2E),
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                  ),
                                  onPressed: () async {
                                    final completed = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GenericRoutineActiveScreen(
                                          routine: routine,
                                          currentStars: currentStars,
                                        ),
                                      ),
                                    );
                                    if (completed == true && context.mounted) {
                                      Navigator.pop(context, true);
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow_rounded, color: Colors.white),
                                      SizedBox(width: 6),
                                      Text('نبدأ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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