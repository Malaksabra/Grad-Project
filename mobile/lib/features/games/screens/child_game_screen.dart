import 'package:flutter/material.dart';

import '../data/level_storage.dart';
import '../data/shared_preferences_level_storage.dart';
import '../logic/day_key.dart';
import '../logic/games_settings.dart';
import '../widgets/child_done_view.dart';
import 'game_launcher.dart';

/// What the child sees when opening the games: only the game and the level
/// the parent chose, with no list and no choices.
///
/// The child plays it once a day. When the round ends (the child wins, or the
/// time is up) the game is locked until the next day, and the page shows a
/// "done for today" message instead.
class ChildGameScreen extends StatefulWidget {
  const ChildGameScreen({super.key, this.storage, this.now});

  /// Where the parent's choice is saved. Defaults to the phone's storage.
  final LevelStorage? storage;

  /// The current time. For tests only: lets a test choose the day.
  final DateTime Function()? now;

  @override
  State<ChildGameScreen> createState() => _ChildGameScreenState();
}

class _ChildGameScreenState extends State<ChildGameScreen> {
  late final GamesSettings _settings;
  bool _isLoaded = false;
  bool _isDoneToday = false;

  String get _today => dayKey((widget.now ?? DateTime.now)());

  @override
  void initState() {
    super.initState();
    _settings = GamesSettings(
      widget.storage ?? SharedPreferencesLevelStorage(),
    );
    _load();
  }

  // The choice and the finished day are read every time this page opens, so
  // they are always the latest ones.
  Future<void> _load() async {
    await _settings.load();
    if (!mounted) return;
    setState(() {
      _isDoneToday = _settings.isFinishedOn(_today);
      _isLoaded = true;
    });
  }

  // Only saves the day. The page is not rebuilt, so the child still sees the
  // end of the round until leaving.
  void _onFinished() => _settings.markFinished(_today);

  @override
  void dispose() {
    _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const Scaffold(backgroundColor: Colors.white);
    if (_isDoneToday) return const ChildDoneView();
    return buildGameScreen(
      _settings.selectedGame,
      _settings.selectedLevel,
      isForChild: true,
      onFinished: _onFinished,
    );
  }
}
