import 'package:flutter/material.dart';

import '../social_activities.dart';
import '../social_situations_colors.dart';
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
  static const double _cardAspectRatio = 1.1;
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
                icon: const Icon(Icons.groups),
                backgroundColor: SocialSituationsColors.background,
                edgeColor: SocialSituationsColors.edge,
                textColor: SocialSituationsColors.text,
              ),
              const SizedBox(height: _gap),
              Expanded(
                child: GridView.count(
                  crossAxisCount: _columnCount,
                  mainAxisSpacing: _gap,
                  crossAxisSpacing: _gap,
                  childAspectRatio: _cardAspectRatio,
                  padding: const EdgeInsets.only(bottom: _gridBottomPadding),
                  children: [
                    for (final activity in socialActivities)
                      ActivityCard(
                        title: activity.title,
                        icon: Icon(activity.icon),
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
