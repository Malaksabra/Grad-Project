import 'package:flutter/material.dart';

import '../social_activities.dart';
import '../social_situations_colors.dart';
import '../social_situations_images.dart';
import '../social_situations_texts.dart';
import '../widgets/activity_card.dart';
import '../widgets/section_progress_card.dart';

/// Home screen of the social situations section.
class SocialSituationsScreen extends StatelessWidget {
  const SocialSituationsScreen({super.key});

  // Placeholder until the child's real progress is stored.
  static const int _completedActivities = 0;

  static const double _screenPadding = 20;
  static const double _gap = 16;
  static const double _gridBottomPadding = 8;
  static const double _minCardHeight = 150;
  static const double _maxCardHeight = 280;
  static const int _columnCount = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(_screenPadding),
          child: Column(
            children: [
              SectionProgressCard(
                title: SocialSituationsTexts.sectionTitle,
                progressText: SocialSituationsTexts.progress(
                  completed: _completedActivities,
                  total: socialActivities.length,
                ),
                icon: Image.asset(SocialSituationsImages.section),
                backgroundColor: SocialSituationsColors.background,
                edgeColor: SocialSituationsColors.edge,
                textColor: SocialSituationsColors.text,
              ),
              const SizedBox(height: _gap),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final cardHeight = _cardHeightFor(
                      context,
                      constraints.maxHeight,
                    );
                    return GridView(
                      padding: const EdgeInsets.only(
                        bottom: _gridBottomPadding,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _columnCount,
                        mainAxisSpacing: _gap,
                        crossAxisSpacing: _gap,
                        mainAxisExtent: cardHeight,
                      ),
                      children: [
                        for (final activity in socialActivities)
                          ActivityCard(
                            title: activity.title,
                            icon: Image.asset(activity.imagePath),
                            backgroundColor: SocialSituationsColors.background,
                            edgeColor: SocialSituationsColors.edge,
                            textColor: SocialSituationsColors.text,
                            // Navigation is added together with the activity screens.
                            onTap: () {},
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Fills the available height with the card rows, so a normal phone needs
  /// no scrolling. The cards never get smaller than their content needs,
  /// even with a big text size.
  double _cardHeightFor(BuildContext context, double availableHeight) {
    final textScaler = MediaQuery.textScalerOf(context);
    final rowCount = (socialActivities.length / _columnCount).ceil();
    final heightForRows =
        (availableHeight - _gridBottomPadding - _gap * (rowCount - 1)) /
        rowCount;

    return heightForRows
        .clamp(
          textScaler.scale(_minCardHeight),
          textScaler.scale(_maxCardHeight),
        )
        .toDouble();
  }
}
