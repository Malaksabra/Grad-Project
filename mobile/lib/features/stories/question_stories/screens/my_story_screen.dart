import 'package:flutter/material.dart';

import '../../stories_colors.dart';
import '../../stories_texts.dart';
import '../../widgets/story_navigation_button.dart';
import '../../widgets/story_sentence_card.dart';

/// The whole story, told by the child with the sentences collected from the
/// correct answers.
class MyStoryScreen extends StatelessWidget {
  const MyStoryScreen({super.key, required this.title, required this.lines});

  final String title;
  final List<String> lines;

  static const double _screenPadding = 20;
  static const double _gap = 16;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(_screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StorySentenceCard(
                text: title,
                backgroundColor: StoriesColors.edge,
                edgeColor: StoriesColors.text,
                textColor: Colors.white,
              ),
              const SizedBox(height: _gap),
              Expanded(
                child: ListView.separated(
                  itemCount: lines.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: _gap),
                  itemBuilder: (context, index) => StorySentenceCard(
                    text: lines[index],
                    backgroundColor: StoriesColors.background,
                    edgeColor: StoriesColors.edge,
                    textColor: StoriesColors.text,
                  ),
                ),
              ),
              const SizedBox(height: _gap),
              StoryNavigationButton(
                label: StoriesTexts.finish,
                backgroundColor: StoriesColors.background,
                edgeColor: StoriesColors.edge,
                textColor: StoriesColors.text,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
