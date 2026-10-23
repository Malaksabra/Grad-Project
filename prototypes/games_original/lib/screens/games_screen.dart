import 'package:flutter/material.dart';
import 'package:project_games/theme.dart';

class GamesScreen extends StatelessWidget {
  final VoidCallback onOpenMemory;
  const GamesScreen({super.key, required this.onOpenMemory});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ThickBox(
              fill: gameHue.h,
              border: gameHue.hs,
              radius: BorderRadius.circular(30),
              side: 0,
              top: 0,
              bottom: 6,
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle),
                    child: const Text('🎮', style: TextStyle(fontSize: 33)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الألعاب',
                            style: displayStyle(size: 24, color: gameHue.hi)),
                        Text('ألعب وأفكّر',
                            style: bodyStyle(size: 15.2, color: gameHue.hi)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ActivityCard(
            title: 'Memory cards',
            image: 'assets/Memory.jpeg',
            onTap: onOpenMemory,
          ),
          // لعبة جديدة: انسخي _ActivityCard هنا وحطي قبلها SizedBox(height: 12)
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final String title, image;
  final VoidCallback onTap;
  const _ActivityCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ThickBox(
        fill: gameHue.h,
        border: gameHue.hs,
        radius: BorderRadius.circular(30),
        side: 0,
        top: 0,
        bottom: 6,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: AspectRatio(
                aspectRatio: 2 / 1,
                child: Image.asset(
                  image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: bodyStyle(
                  size: 17.6, weight: FontWeight.w500, color: gameHue.hi),
            ),
          ],
        ),
      ),
    );
  }
}