import 'package:flutter/material.dart';

import '../../stories_colors.dart';
import '../../stories_texts.dart';
import '../../widgets/story_navigation_button.dart';
import '../../widgets/story_page_image.dart';
import '../../widgets/story_sentence_card.dart';
import '../logic/question_story_session.dart';
import '../models/question_story_models.dart';
import '../models/story_profile.dart';
import '../question_stories_colors.dart';
import '../question_stories_texts.dart';
import '../widgets/question_story_top_bar.dart';
import '../widgets/story_choices.dart';
import 'my_story_screen.dart';

/// Shows a story picture by picture. Under each picture there is a question;
/// a correct answer makes the child "tell" that part of the story.
class QuestionStoryScreen extends StatefulWidget {
  const QuestionStoryScreen({
    super.key,
    required this.story,
    required this.profile,
    required this.myStoryTitle,
  });

  final QuestionStory story;
  final StoryProfile profile;

  /// Title of the final "my story" page, may hold the `{child}` marker.
  final String myStoryTitle;

  @override
  State<QuestionStoryScreen> createState() => _QuestionStoryScreenState();
}

class _QuestionStoryScreenState extends State<QuestionStoryScreen> {
  static const double _screenPadding = 20;
  static const double _gap = 20;
  static const double _imageRadius = 24;
  // The pictures are made at this shape, so the whole picture is visible.
  static const double _imageAspectRatio = 1024 / 559;

  late final QuestionStorySession _session = QuestionStorySession(
    story: widget.story,
    profile: widget.profile,
  );

  void _choose(int choiceIndex) {
    setState(() => _session.choose(choiceIndex));
  }

  void _goToNext() {
    if (_session.isLastStep) {
      _openMyStory();
    } else {
      setState(_session.next);
    }
  }

  void _openMyStory() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => MyStoryScreen(
          title: widget.profile.fill(widget.myStoryTitle),
          lines: _session.toldLines,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final page = _session.currentPage;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(_screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuestionStoryTopBar(
                pageCount: _session.stepCount,
                currentIndex: _session.stepIndex,
              ),
              const SizedBox(height: _gap),
              ClipRRect(
                borderRadius: BorderRadius.circular(_imageRadius),
                child: AspectRatio(
                  aspectRatio: _imageAspectRatio,
                  child: StoryPageImage(
                    imagePath: page.imagePath,
                    fallbackColor: StoriesColors.background,
                  ),
                ),
              ),
              const SizedBox(height: _gap),
              StorySentenceCard(
                text: page.questionFor(widget.profile),
                backgroundColor: StoriesColors.background,
                edgeColor: StoriesColors.edge,
                textColor: StoriesColors.text,
              ),
              const SizedBox(height: _gap),
              StoryChoices(session: _session, onChoose: _choose),
              const SizedBox(height: _gap),
              _buildFeedback(),
              StoryNavigationButton(
                label: _session.isLastStep
                    ? StoriesTexts.finish
                    : StoriesTexts.next,
                backgroundColor: StoriesColors.background,
                edgeColor: StoriesColors.edge,
                textColor: StoriesColors.text,
                onPressed: _session.isAnswered ? _goToNext : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// After a correct answer: the sentence the child "told", or a short
  /// praise on practice questions. After a wrong answer: a gentle retry.
  Widget _buildFeedback() {
    if (_session.isAnswered) {
      return Padding(
        padding: const EdgeInsets.only(bottom: _gap),
        child: StorySentenceCard(
          text: _session.currentLine ?? _praise(),
          backgroundColor: QuestionStoriesColors.correctBackground,
          edgeColor: QuestionStoriesColors.correctEdge,
          textColor: StoriesColors.text,
        ),
      );
    }
    if (_session.hasWrongAnswer) {
      return Padding(
        padding: const EdgeInsets.only(bottom: _gap),
        child: Text(
          QuestionStoriesTexts.tryAgain,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(color: StoriesColors.text),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  String _praise() {
    const praises = QuestionStoriesTexts.praises;
    return praises[_session.stepIndex % praises.length];
  }
}
