import 'package:flutter/material.dart';

import '../data/level_storage.dart';
import '../games_colors.dart';
import '../games_images.dart';
import '../games_styles.dart';
import '../games_texts.dart';
import '../logic/games_settings.dart';
import '../widgets/games_image.dart';
import '../widgets/thick_box.dart';
import 'levels_screen.dart';
import 'memory_game_screen.dart';

/// Home screen of the games section: the list of games.
/// It also owns the settings (the level chosen for the child), so they stay
/// the same while the parent moves between the pages of the section.
class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key, this.storage});

  /// Where the chosen level is saved. Defaults to a temporary storage in
  /// memory, until the team agrees to add shared_preferences.
  final LevelStorage? storage;

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late final GamesSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = GamesSettings(widget.storage ?? InMemoryLevelStorage());
    _settings.load();
  }

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  void _openLevels() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LevelsScreen(settings: _settings, onPlay: _openGame),
      ),
    );
  }

  void _openGame(int levelIndex) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => MemoryGameScreen(levelIndex: levelIndex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SectionHeader(),
              const SizedBox(height: 16),
              _ActivityCard(
                title: GamesTexts.memoryCardsTitle,
                imagePath: GamesImages.memoryCards,
                onTap: _openLevels,
              ),
              // A new game: copy _ActivityCard here, with a SizedBox(height: 12)
              // before it.
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader();

  @override
  Widget build(BuildContext context) {
    return ThickBox(
      fill: GamesColors.background,
      border: GamesColors.edge,
      radius: BorderRadius.circular(30),
      side: 0,
      top: 0,
      bottom: 6,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Text('🎮', style: TextStyle(fontSize: 33)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  GamesTexts.sectionTitle,
                  style: GamesStyles.display(size: 24, color: GamesColors.text),
                ),
                Text(
                  GamesTexts.sectionSubtitle,
                  style: GamesStyles.body(size: 15.2, color: GamesColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  final String title;
  final String imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onTap,
        child: ThickBox(
          fill: GamesColors.background,
          border: GamesColors.edge,
          radius: BorderRadius.circular(30),
          side: 0,
          top: 0,
          bottom: 6,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: AspectRatio(
                  aspectRatio: 2 / 1,
                  child: GamesImage(imagePath),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GamesStyles.body(
                  size: 17.6,
                  weight: FontWeight.w500,
                  color: GamesColors.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
