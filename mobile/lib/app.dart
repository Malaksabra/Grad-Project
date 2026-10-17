import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: AppConstants.appName,
      home: Scaffold(
        body: Center(child: Text(AppConstants.appName)),
      ),
    );
  }
}