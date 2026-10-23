import 'package:flutter/material.dart';
import 'game_settings.dart';
import 'package:project_games/theme.dart';

class LevelsScreen extends StatelessWidget {
  final GameSettings settings;
  final ValueChanged<int> onPlay; // تجربة المستوى
  const LevelsScreen({super.key, required this.settings, required this.onPlay});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: settings,
      builder: (context, _) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const GuideRow(
                text: 'جرّبوا أي مستوى، واختاروا اللي هيظهر للطفل.'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSurface2,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: const Color(0x733DBDB0), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('المستويات', style: displayStyle(size: 19.2)),
                  const SizedBox(height: 6),
                  Text(
                    'اضغطوا على المستوى عشان تجرّبوه. وزرار "اختيار للطفل" بيحدد المستوى اللي الطفل هيلاقيه جاهز.',
                    style: bodyStyle(size: 14.7, color: kFgSoft),
                  ),
                  const SizedBox(height: 14),
                  for (var i = 0; i < kLevelPairs.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _LevelOption(
                        index: i,
                        selected: settings.selected == i,
                        onPlay: () => onPlay(i),
                        onSelect: () => settings.select(i),
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

class _LevelOption extends StatelessWidget {
  final int index;
  final bool selected;
  final VoidCallback onPlay, onSelect;
  const _LevelOption({
    required this.index,
    required this.selected,
    required this.onPlay,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final ink = selected ? gameHue.hi : kFg;
    return Semantics(
      button: true,
      label: 'جرّب المستوى ${kLevelNames[index]}',
      child: GestureDetector(
        onTap: onPlay,
        child: ThickBox(
          fill: selected ? gameHue.h : Colors.white,
          border: selected ? gameHue.hs : kLine,
          radius: BorderRadius.circular(30),
          bottom: 5,
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                          color: selected ? gameHue.hs : kLine, width: 2),
                    ),
                    child: Text('${index + 1}',
                        style: displayStyle(size: 26, color: ink)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('المستوى ${kLevelNames[index]}',
                            style: bodyStyle(
                                size: 17.6,
                                weight: FontWeight.w600,
                                color: ink)),
                        Text(
                            '${kLevelPairs[index] * 2} كروت  ·  ⏱ ${fmtTime(kLevelSeconds[index])}',
                            style: bodyStyle(
                                size: 14.7,
                                color: selected ? gameHue.hi : kFgSoft)),
                      ],
                    ),
                  ),
                  Icon(Icons.play_circle_fill_rounded,
                      size: 40, color: selected ? gameHue.hi : gameHue.hs),
                ],
              ),
              const SizedBox(height: 12),
              Semantics(
                button: true,
                selected: selected,
                label: 'اختيار المستوى ${kLevelNames[index]} للطفل',
                child: GestureDetector(
                  onTap: onSelect,
                  child: ThickBox(
                    fill: selected ? gameHue.hi : Colors.white,
                    border: selected ? gameHue.hi : gameHue.hs,
                    radius: BorderRadius.circular(999),
                    bottom: 4,
                    constraints: const BoxConstraints(minHeight: 46),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (selected) ...[
                          const Icon(Icons.check_rounded,
                              size: 20, color: Colors.white),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          selected ? 'مختار للطفل' : 'اختيار للطفل',
                          style: bodyStyle(
                              size: 15.2,
                              weight: FontWeight.w500,
                              color: selected ? Colors.white : kFg),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}