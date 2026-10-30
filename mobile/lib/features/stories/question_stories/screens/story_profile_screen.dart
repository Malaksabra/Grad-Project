import 'package:flutter/material.dart';

import '../../stories_colors.dart';
import '../../widgets/story_navigation_button.dart';
import '../models/story_profile.dart';
import '../question_stories_texts.dart';

/// Where the parents enter the child's name and the friend's name.
///
/// The screen only returns the names to whoever opened it, through
/// `Navigator.pop`; saving them is not its job. A name left empty keeps
/// the one it started with.
class StoryProfileScreen extends StatefulWidget {
  const StoryProfileScreen({super.key, required this.initialProfile});

  final StoryProfile initialProfile;

  @override
  State<StoryProfileScreen> createState() => _StoryProfileScreenState();
}

class _StoryProfileScreenState extends State<StoryProfileScreen> {
  static const double _screenPadding = 20;
  static const double _gap = 20;
  static const int _maxNameLength = 20;

  late final TextEditingController _childController = TextEditingController(
    text: widget.initialProfile.childName,
  );
  late final TextEditingController _friendController = TextEditingController(
    text: widget.initialProfile.friendName,
  );

  @override
  void dispose() {
    _childController.dispose();
    _friendController.dispose();
    super.dispose();
  }

  void _save() {
    Navigator.of(context).pop(
      StoryProfile(
        childName: _nameOrFallback(
          _childController,
          widget.initialProfile.childName,
        ),
        friendName: _nameOrFallback(
          _friendController,
          widget.initialProfile.friendName,
        ),
      ),
    );
  }

  String _nameOrFallback(TextEditingController controller, String fallback) {
    final name = controller.text.trim();
    return name.isEmpty ? fallback : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(QuestionStoriesTexts.profileTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(_screenPadding),
          children: [
            Text(
              QuestionStoriesTexts.profileHint,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: StoriesColors.text),
            ),
            const SizedBox(height: _gap),
            TextField(
              controller: _childController,
              maxLength: _maxNameLength,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: QuestionStoriesTexts.childNameLabel,
                counterText: '',
              ),
            ),
            const SizedBox(height: _gap),
            TextField(
              controller: _friendController,
              maxLength: _maxNameLength,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: QuestionStoriesTexts.friendNameLabel,
                counterText: '',
              ),
              onSubmitted: (_) => _save(),
            ),
            const SizedBox(height: _gap),
            StoryNavigationButton(
              label: QuestionStoriesTexts.saveAndStart,
              backgroundColor: StoriesColors.background,
              edgeColor: StoriesColors.edge,
              textColor: StoriesColors.text,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}
