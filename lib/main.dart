import 'package:flutter/material.dart';

import 'core/theme/theme.dart';
import 'features/dashboard/dashboard_screen.dart';

void main() {
  runApp(const AuraHealthApp());
}

class AuraHealthApp extends StatelessWidget {
  const AuraHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AuraHealth',
      debugShowCheckedModeBanner: false,
      theme: DarkGlassTheme.theme,
      home: const DashboardScreen(),
    );
  }
}
