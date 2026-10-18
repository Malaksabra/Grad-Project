import 'package:flutter_test/flutter_test.dart';
import 'package:grad_project/app.dart';
import 'package:grad_project/core/constants/app_constants.dart';

void main() {
  testWidgets('App shows the project name', (tester) async {
    await tester.pumpWidget(const App());

    expect(find.text(AppConstants.appName), findsOneWidget);
  });
}
