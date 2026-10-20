import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/app.dart';
import 'package:grad_project/core/navigation/app_tab.dart';
import 'package:grad_project/features/social_situations/screens/social_situations_screen.dart';
import 'package:grad_project/shared/widgets/section_placeholder.dart';

void main() {
  // A phone-sized screen, so the tab bar is tested like on a real device.
  void useSmallPhone(WidgetTester tester) {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
  }

  testWidgets('shows a tab for every section', (tester) async {
    useSmallPhone(tester);

    await tester.pumpWidget(const App());

    for (final tab in AppTab.values) {
      expect(find.text(tab.label), findsWidgets);
    }
  });

  testWidgets('tapping a tab shows its page', (tester) async {
    useSmallPhone(tester);
    await tester.pumpWidget(const App());

    await tester.tap(find.text(AppTab.communication.label));
    await tester.pumpAndSettle();

    expect(
      find.widgetWithText(SectionPlaceholder, AppTab.communication.label),
      findsOneWidget,
    );
  });

  testWidgets('the social situations tab shows its screen', (tester) async {
    useSmallPhone(tester);
    await tester.pumpWidget(const App());

    await tester.tap(find.text(AppTab.socialSituations.label));
    await tester.pumpAndSettle();

    expect(find.byType(SocialSituationsScreen), findsOneWidget);
  });

  testWidgets('does not overflow when the text size is doubled', (
    tester,
  ) async {
    useSmallPhone(tester);
    tester.platformDispatcher.textScaleFactorTestValue = 2.0;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const App());

    expect(tester.takeException(), isNull);
  });
}
