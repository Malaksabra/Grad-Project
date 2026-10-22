import 'package:flutter/material.dart';

import '../models/story.dart';
import '../social_situations_colors.dart';
import '../social_situations_texts.dart';
import '../widgets/story_navigation_button.dart';
import '../widgets/story_page_image.dart';
import '../widgets/story_progress_dots.dart';
import '../widgets/story_sentence_card.dart';

/// Shows a story page by page, with previous and next buttons.
/// The picture fills the screen and the controls sit on top of it.
class StoryViewerScreen extends StatefulWidget {
  const StoryViewerScreen({super.key, required this.story});

  final Story story;

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  static const double _screenPadding = 20;
  static const double _gap = 20;

  int _pageIndex = 0;

  bool get _isFirstPage => _pageIndex == 0;
  bool get _isLastPage => _pageIndex == widget.story.pages.length - 1;

  void _goToPrevious() {
    setState(() => _pageIndex--);
  }

  void _goToNext() {
    if (_isLastPage) {
      Navigator.of(context).pop();
    } else {
      setState(() => _pageIndex++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = widget.story.pages;
    final page = pages[_pageIndex];

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          StoryPageImage(
            imagePath: page.imagePath,
            fallbackColor: SocialSituationsColors.background,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(_screenPadding),
              child: Column(
                children: [
                  _TopBar(pageCount: pages.length, currentIndex: _pageIndex),
                  const Spacer(),
                  StorySentenceCard(
                    text: page.text,
                    backgroundColor: SocialSituationsColors.background,
                    edgeColor: SocialSituationsColors.edge,
                    textColor: SocialSituationsColors.text,
                  ),
                  const SizedBox(height: _gap),
                  Row(
                    children: [
                      Expanded(
                        child: StoryNavigationButton(
                          label: SocialSituationsTexts.previous,
                          backgroundColor: SocialSituationsColors.background,
                          edgeColor: SocialSituationsColors.edge,
                          textColor: SocialSituationsColors.text,
                          onPressed: _isFirstPage ? null : _goToPrevious,
                        ),
                      ),
                      const SizedBox(width: _gap),
                      Expanded(
                        child: StoryNavigationButton(
                          label: _isLastPage
                              ? SocialSituationsTexts.finish
                              : SocialSituationsTexts.next,
                          backgroundColor: SocialSituationsColors.background,
                          edgeColor: SocialSituationsColors.edge,
                          textColor: SocialSituationsColors.text,
                          onPressed: _goToNext,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The close button and the progress dots, on a soft white background so
/// they stay readable over any picture.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.pageCount, required this.currentIndex});

  final int pageCount;
  final int currentIndex;

  static const double _radius = 28;
  static const double _backgroundAlpha = 0.85;
  static const double _buttonSize = 48;
  static const double _inactiveDotAlpha = 0.35;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: _backgroundAlpha),
        borderRadius: BorderRadius.circular(_radius),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: SocialSituationsTexts.back,
            color: SocialSituationsColors.text,
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
          ),
          Expanded(
            child: Center(
              child: StoryProgressDots(
                count: pageCount,
                currentIndex: currentIndex,
                activeColor: SocialSituationsColors.edge,
                inactiveColor: SocialSituationsColors.edge.withValues(
                  alpha: _inactiveDotAlpha,
                ),
              ),
            ),
          ),
          // Keeps the dots centered, same width as the close button.
          const SizedBox(width: _buttonSize),
        ],
      ),
    );
  }
}
