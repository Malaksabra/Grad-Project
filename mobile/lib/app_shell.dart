import 'package:flutter/material.dart';
import 'features/communication/screens/communication_screen.dart';
import 'core/navigation/app_tab.dart';
import 'core/navigation/app_tab_bar.dart';
import 'features/social_situations/screens/social_situations_screen.dart';
import 'shared/widgets/section_placeholder.dart';

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

  // Replace a placeholder with the real screen when its section is ready.
  Widget _pageFor(AppTab tab) {
    return switch (tab) {
      AppTab.home => SectionPlaceholder(title: tab.label),
      AppTab.communication => const CommunicationScreen(),
      AppTab.routines => SectionPlaceholder(title: tab.label),
      AppTab.socialSituations => const SocialSituationsScreen(),
      AppTab.play => SectionPlaceholder(title: tab.label),
    };
  }
}
