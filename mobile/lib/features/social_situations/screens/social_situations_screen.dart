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
  static const double _baseCardHeight = 170;
  static const int _columnCount = 2;

  @override
  Widget build(BuildContext context) {
    // Cards grow with the user's text size, so titles are never cut off.
    final cardHeight = MediaQuery.textScalerOf(context).scale(_baseCardHeight);

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
                child: GridView(
                  padding: const EdgeInsets.only(bottom: _gridBottomPadding),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
