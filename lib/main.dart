// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/theme.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/chat/neural_chat_screen.dart';
import 'features/vitals/vitals_detail_view.dart';

void main() {
  runApp(const AuraHealthApp());
}

class AuraHealthApp extends StatelessWidget {
  const AuraHealthApp({super.key});

  static final GoRouter _router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const NeuralChatScreen(),
      ),
      GoRoute(
        path: '/vitals',
        builder: (context, state) => const VitalsDetailView(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'AuraHealth',
        debugShowCheckedModeBanner: false,
        theme: DarkGlassTheme.theme,
        routerConfig: _router,
      ),
    );
  }
}
