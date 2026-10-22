import 'package:flutter/foundation.dart';

enum HomeSection { communication, dailyRoutine, socialSituations }

///  [markStepCompleted]

class HomeProgress extends ChangeNotifier {
  HomeProgress._();

  static final HomeProgress instance = HomeProgress._();

  static const Map<HomeSection, int> _totals = {
    HomeSection.communication: 2,
    HomeSection.dailyRoutine: 4,
    HomeSection.socialSituations: 4,
  };

  final Map<HomeSection, int> _completed = {
    for (final section in HomeSection.values) section: 0,
  };

  int _stars = 0;

  int get stars => _stars;

  int completedOf(HomeSection section) => _completed[section]!;

  int totalOf(HomeSection section) => _totals[section]!;

  void markStepCompleted(HomeSection section) {
    if (completedOf(section) >= totalOf(section)) return;
    _completed[section] = completedOf(section) + 1;
    notifyListeners();
  }

  void addStars(int amount) {
    _stars += amount;
    notifyListeners();
  }
}