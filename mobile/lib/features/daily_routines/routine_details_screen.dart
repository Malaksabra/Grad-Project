import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'routine_model.dart';
import 'generic_routine_list_screen.dart';

class RoutineDetailsScreen extends StatefulWidget {
  const RoutineDetailsScreen({super.key});

  @override
  State<RoutineDetailsScreen> createState() => _RoutineDetailsScreenState();
}

class _RoutineDetailsScreenState extends State<RoutineDetailsScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // حالات إنجاز الروتينات الستة
  bool isBedDone = false;
  bool isBathroomDone = false;
  bool isClothesDone = false;
  bool isBreakfastDone = false;
  bool isTeethDone = false;
  bool isBagDone = false;

  Future<void> _playSound() async {
    try {
      await _audioPlayer.play(UrlSource('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'));
    } catch (e) {
      debugPrint("خطأ في تشغيل الصوت: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int totalStars = 0;
    if (isBedDone) totalStars += 20;
    if (isBathroomDone) totalStars += 20;
    if (isClothesDone) totalStars += 20;
    if (isBreakfastDone) totalStars += 20;
    if (isTeethDone) totalStars += 20;
    if (isBagDone) totalStars += 20;

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
                        Text('$totalStars', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 6),
                        const Icon(Icons.star_rounded, color: Color(0xFFF5B82E), size: 24),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'الصبح',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E2A44)),
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
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3F6E8),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.volume_up_rounded, color: Color(0xFF4CBB7F)),
                              onPressed: _playSound,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'ده جدول الروتين بتاعنا. هنعمل كل حاجة بالترتيب وبشكل جميل!',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            backgroundColor: Color(0xFFFFE0B2),
                            child: Text('🐻', style: TextStyle(fontSize: 20)),
                          ),
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
                              const Text(
                                'جدول الروتين',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Text(
                                  'الوقت كله 51:00',
                                  style: TextStyle(fontSize: 12, color: Color(0xFF1B4D2E), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // 1. أرتّب سريري
                          if (isBedDone)
                            _buildDoneItem(morningRoutinesData[0].title, morningRoutinesData[0].icon)
                          else
                            _buildActiveItem(morningRoutinesData[0].totalTimeString, morningRoutinesData[0].title, morningRoutinesData[0].icon, () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenericRoutineListScreen(routine: morningRoutinesData[0], currentStars: totalStars),
                                ),
                              );
                              if (res == true) setState(() => isBedDone = true);
                            }),

                          const SizedBox(height: 6),

                          // 2. الحمام
                          if (isBathroomDone)
                            _buildDoneItem(morningRoutinesData[1].title, morningRoutinesData[1].icon)
                          else if (isBedDone)
                            _buildActiveItem(morningRoutinesData[1].totalTimeString, morningRoutinesData[1].title, morningRoutinesData[1].icon, () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenericRoutineListScreen(routine: morningRoutinesData[1], currentStars: totalStars),
                                ),
                              );
                              if (res == true) setState(() => isBathroomDone = true);
                            })
                          else
                            _buildRoutineItem(morningRoutinesData[1].totalTimeString, morningRoutinesData[1].title, morningRoutinesData[1].icon),

                          const SizedBox(height: 6),

                          // 3. ألبس هدومي
                          if (isClothesDone)
                            _buildDoneItem(morningRoutinesData[2].title, morningRoutinesData[2].icon)
                          else if (isBathroomDone)
                            _buildActiveItem(morningRoutinesData[2].totalTimeString, morningRoutinesData[2].title, morningRoutinesData[2].icon, () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenericRoutineListScreen(routine: morningRoutinesData[2], currentStars: totalStars),
                                ),
                              );
                              if (res == true) setState(() => isClothesDone = true);
                            })
                          else
                            _buildRoutineItem(morningRoutinesData[2].totalTimeString, morningRoutinesData[2].title, morningRoutinesData[2].icon),

                          const SizedBox(height: 6),

                          // 4. أفطر
                          if (isBreakfastDone)
                            _buildDoneItem(morningRoutinesData[3].title, morningRoutinesData[3].icon)
                          else if (isClothesDone)
                            _buildActiveItem(morningRoutinesData[3].totalTimeString, morningRoutinesData[3].title, morningRoutinesData[3].icon, () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenericRoutineListScreen(routine: morningRoutinesData[3], currentStars: totalStars),
                                ),
                              );
                              if (res == true) setState(() => isBreakfastDone = true);
                            })
                          else
                            _buildRoutineItem(morningRoutinesData[3].totalTimeString, morningRoutinesData[3].title, morningRoutinesData[3].icon),

                          const SizedBox(height: 6),

                          // 5. أنضف سناني
                          if (isTeethDone)
                            _buildDoneItem(morningRoutinesData[4].title, morningRoutinesData[4].icon)
                          else if (isBreakfastDone)
                            _buildActiveItem(morningRoutinesData[4].totalTimeString, morningRoutinesData[4].title, morningRoutinesData[4].icon, () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenericRoutineListScreen(routine: morningRoutinesData[4], currentStars: totalStars),
                                ),
                              );
                              if (res == true) setState(() => isTeethDone = true);
                            })
                          else
                            _buildRoutineItem(morningRoutinesData[4].totalTimeString, morningRoutinesData[4].title, morningRoutinesData[4].icon),

                          const SizedBox(height: 6),

                          // 6. أجهز شنطي
                          if (isBagDone)
                            _buildDoneItem(morningRoutinesData[5].title, morningRoutinesData[5].icon)
                          else if (isTeethDone)
                            _buildActiveItem(morningRoutinesData[5].totalTimeString, morningRoutinesData[5].title, morningRoutinesData[5].icon, () async {
                              final res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => GenericRoutineListScreen(routine: morningRoutinesData[5], currentStars: totalStars),
                                ),
                              );
                              if (res == true) setState(() => isBagDone = true);
                            })
                          else
                            _buildRoutineItem(morningRoutinesData[5].totalTimeString, morningRoutinesData[5].title, morningRoutinesData[5].icon),
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

  Widget _buildDoneItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(16)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.check, color: Color(0xFF1B4D2E), size: 24),
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
              const SizedBox(width: 10),
              Icon(icon, color: const Color(0xFF6C7BD9)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveItem(String time, String title, IconData icon, VoidCallback onTap) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1B4D2E), width: 2),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
              Row(
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
                  const SizedBox(width: 10),
                  Icon(icon, color: const Color(0xFF6C7BD9)),
                ],
              ),
              const Text('دلوقتي', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4CBB7F))),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B4D2E),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: onTap,
              child: const Text('نبدأ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutineItem(String time, String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(time, style: const TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B4D2E))),
              const SizedBox(width: 10),
              Icon(icon, color: const Color(0xFF6C7BD9), size: 22),
            ],
          ),
        ],
      ),
    );
  }
}