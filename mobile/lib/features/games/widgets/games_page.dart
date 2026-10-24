import 'package:flutter/material.dart';

import 'games_top_bar.dart';

/// A page inside the games section: a top bar with a back button, and the
/// content under it. The back button closes the page.
class GamesPage extends StatelessWidget {
  const GamesPage({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            GamesTopBar(
              title: title,
              onBack: () => Navigator.of(context).maybePop(),
            ),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
