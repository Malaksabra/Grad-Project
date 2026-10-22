import 'package:flutter/material.dart';

import '../home_style.dart';

class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.description,
    required this.iconAsset,
    required this.colors,
    required this.completed,
    required this.total,
    required this.onTap,
  });

  final String title;
  final String description;
  final String iconAsset;
  final HomeSectionColors colors;
  final int completed;
  final int total;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final borderRadius = BorderRadius.circular(HomeStyle.cardRadius);

    return Container(

      padding: const EdgeInsets.only(bottom: HomeStyle.cardDepth),
      decoration: BoxDecoration(
        color: colors.accent,
        borderRadius: borderRadius,
      ),

      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          decoration: BoxDecoration(
            color: colors.background,
            borderRadius: borderRadius,
          ),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: HomeStyle.iconCircleSize,
                    height: HomeStyle.iconCircleSize,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: HomeStyle.iconCircle,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(iconAsset, width: HomeStyle.iconSize),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: textTheme.headlineSmall?.copyWith(
                            fontFamily: HomeStyle.headingFont,
                            fontWeight: FontWeight.w700,
                            color: colors.title,
                          ),
                        ),
                        Text(
                          '$description . خلّصت $completed من $total',
                          style: textTheme.bodyMedium?.copyWith(
                            fontFamily: HomeStyle.bodyFont,
                            fontWeight: FontWeight.w500,
                            color: colors.title,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _ProgressBar(
                          value: total == 0 ? 0 : completed / total,
                          color: colors.accent,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_left, color: colors.title, size: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value, required this.color});

  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(HomeStyle.progressHeight),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: value),
        duration: const Duration(milliseconds: 400),
        builder: (context, animatedValue, _) => LinearProgressIndicator(
          value: animatedValue,
          minHeight: HomeStyle.progressHeight,
          backgroundColor: HomeStyle.progressTrack,
          valueColor: AlwaysStoppedAnimation<Color>(color),
        ),
      ),
    );
  }
}