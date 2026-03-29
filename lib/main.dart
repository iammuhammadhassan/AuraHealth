import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/theme.dart';
import 'features/chat/neural_chat_screen.dart';

void main() {
  runApp(const AuraHealthApp());
}

class AuraHealthApp extends StatelessWidget {
  const AuraHealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'AuraHealth',
        debugShowCheckedModeBanner: false,
        theme: DarkGlassTheme.theme,
        home: const NeuralChatScreen(),
      ),
    );
  }
}
