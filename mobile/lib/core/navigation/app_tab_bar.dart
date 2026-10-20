import 'package:flutter/material.dart';

import 'app_tab.dart';

/// The bottom bar: one tab per section; the selected tab has a colored background.
class AppTabBar extends StatelessWidget {
  const AppTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final AppTab selectedTab;
  final ValueChanged<AppTab> onTabSelected;

  static const double _elevation = 8;
  static const double _barPadding = 8;
  static const double _baseTabHeight = 88;

  @override
  Widget build(BuildContext context) {
    // Tabs grow with the user's text size, so labels are never cut off.
    final tabHeight = MediaQuery.textScalerOf(context).scale(_baseTabHeight);

    return Material(
      elevation: _elevation,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(_barPadding),
          child: Row(
            children: [
              for (final tab in AppTab.values)
                Expanded(
                  child: _TabItem(
                    tab: tab,
                    height: tabHeight,
                    isSelected: tab == selectedTab,
                    onTap: () => onTabSelected(tab),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.tab,
    required this.height,
    required this.isSelected,
    required this.onTap,
  });

  final AppTab tab;
  final double height;
  final bool isSelected;
  final VoidCallback onTap;

  static const double _radius = 20;
  static const double _iconSize = 32;
  static const double _spacing = 4;
  static const double _labelFontSize = 12;
  static const Duration _animationDuration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelColor = isSelected
        ? tab.palette.text
        : theme.colorScheme.onSurfaceVariant;

    return InkWell(
      borderRadius: BorderRadius.circular(_radius),
      onTap: onTap,
      child: AnimatedContainer(
        duration: _animationDuration,
        height: height,
        decoration: BoxDecoration(
          color: isSelected ? tab.palette.background : Colors.transparent,
          borderRadius: BorderRadius.circular(_radius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(tab.imagePath, width: _iconSize, height: _iconSize),
            const SizedBox(height: _spacing),
            Text(
              tab.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                color: labelColor,
                fontSize: _labelFontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
