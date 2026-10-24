import 'package:flutter/material.dart';

import '../../../shared/widgets/section_top_bar.dart';

import '../../social_situations/widgets/activity_card.dart';
import '../../social_situations/widgets/section_progress_card.dart';
import '../communication_colors.dart';
import '../communication_data.dart';
import '../communication_models.dart';
import '../communication_texts.dart';
import '../widgets/emoji_icon.dart';
import 'signs_screen.dart';
import 'what_i_want_screen.dart';

/// Home screen of the communication section.
class CommunicationScreen extends StatelessWidget {
  const CommunicationScreen({super.key, required this.onBack});

  final VoidCallback onBack;

  // Placeholder until the child's real progress is stored.
  static const int _completedActivities = 0;

  static const double _screenPadding = 20;
  static const double _gap = 16;
  static const double _baseCardHeight = 170;

  @override
  Widget build(BuildContext context) {
    // Cards grow with the text size, so titles are never cut off.
    final cardHeight = MediaQuery.textScalerOf(context).scale(_baseCardHeight);

    return Scaffold(
      appBar: SectionAppBar(onBack: onBack),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(_screenPadding),
          children: [
            SectionProgressCard(
              title: CommunicationTexts.sectionTitle,
              progressText: CommunicationTexts.progress(
                completed: _completedActivities,
                total: communicationActivities.length,
              ),
              icon: const EmojiIcon(emoji: communicationSectionEmoji),
              backgroundColor: CommunicationColors.background,
              edgeColor: CommunicationColors.edge,
              textColor: CommunicationColors.text,
            ),
            for (final activity in communicationActivities) ...[
              const SizedBox(height: _gap),
              SizedBox(
                height: cardHeight,
                child: ActivityCard(
                  title: activity.title,
                  icon: EmojiIcon(emoji: activity.emoji),
                  backgroundColor: activity.hue.background,
                  edgeColor: activity.hue.edge,
                  textColor: activity.hue.text,
                  onTap: () => _openActivity(context, activity),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Opens the page of a card. Each new page adds one line to this switch.
  void _openActivity(BuildContext context, CommunicationActivity activity) {
    final Widget? screen = switch (activity.title) {
      CommunicationTexts.whatIWant => const WhatIWantScreen(),
      CommunicationTexts.signs => const SignsScreen(),
      _ => null,
    };
    if (screen == null) return;

    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
  }
}