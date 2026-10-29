import 'package:flutter/material.dart';
import 'features/communication/screens/communication_screen.dart';
import 'core/navigation/app_tab.dart';
import 'core/navigation/app_tab_bar.dart';
import 'features/daily_routines/daily_routines_screen.dart';
import 'features/Home/home_progress.dart';
import 'features/Home/home_screen.dart';
import 'features/games/screens/games_screen.dart';
import 'features/social_situations/screens/social_situations_screen.dart';
// 1. استيراد شاشة الدوائر البصرية للطفل
import 'features/home/child_dashboard_screen.dart';

/// The main frame of the app: the current section page and the tab bar.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppTab _selectedTab = AppTab.home;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps every page alive, so a tab keeps its state.
      body: IndexedStack(
        index: _selectedTab.index,
        children: [for (final tab in AppTab.values) _pageFor(tab)],
      ),
      bottomNavigationBar: AppTabBar(
        selectedTab: _selectedTab,
        onTabSelected: _selectTab,
      ),
    );
  }

  void _selectTab(AppTab tab) {
    setState(() => _selectedTab = tab);
  }

  void _goHome() => _selectTab(AppTab.home);

  // 2. توجيه الـ Tabs بحيث تظهر شاشة الأهلي في الرئيسية، وشاشة الطفل في تاب الألعاب أو التاب المخصصة
  Widget _pageFor(AppTab tab) {
    return switch (tab) {
    // شاشة الأهلي الأصلية تظهر عند فتح التطبيق (التاب الرئيسية)
      AppTab.home => HomeScreen(
        onSectionTap: (section) => _selectTab(switch (section) {
          HomeSection.communication => AppTab.communication,
          HomeSection.dailyRoutine => AppTab.routines,
          HomeSection.socialSituations => AppTab.socialSituations,
        }),
      ),
      AppTab.communication => CommunicationScreen(onBack: _goHome),
      AppTab.routines => DailyRoutinesScreen(onBack: _goHome),
      AppTab.socialSituations => SocialSituationsScreen(onBack: _goHome),

    // هنا جعلنا شاشة الطفل بالدوائر البصرية تظهر عند الضغط على تاب الألعاب (أو الـ Tab الخاص بها)
      AppTab.play => const ChildDashboardScreen(),
    };
  }
}