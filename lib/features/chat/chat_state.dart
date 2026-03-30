import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/gemini_service.dart';

final chatStateProvider = StateNotifierProvider<ChatStateNotifier, ChatState>((
  ref,
) {
  return ChatStateNotifier(ref.watch(geminiServiceProvider));
});

final geminiServiceProvider = Provider((ref) => GeminiService());

class ChatState {
  const ChatState({required this.messages});

  final List<ChatMessage> messages;

  ChatState copyWith({List<ChatMessage>? messages}) {
    return ChatState(messages: messages ?? this.messages);
  }

  factory ChatState.initial() {
    return const ChatState(
      messages: [
        ChatMessage(
          text:
              'Hello, I am your health assistant. Share your symptoms, vitals, medications, or concerns, and I will provide clear clinical guidance.',
          role: ChatRole.ai,
        ),
      ],
    );
  }
}

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier(this._geminiService) : super(ChatState.initial());

  final GeminiService _geminiService;

  Future<void> sendUserMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final updated = [
      ...state.messages,
      ChatMessage(text: trimmed, role: ChatRole.user),
    ];
    state = state.copyWith(messages: updated);

    if (trimmed.toLowerCase() == '/diagnose') {
      final diagnosis = _geminiService.buildTroubleshootingMessage();
      addAiMessage(diagnosis);
      return;
    }

    try {
      final aiResponse = await _geminiService.getResponse(trimmed);
      addAiMessage(aiResponse);
    } catch (e) {
      final fallback = _buildOfflineAssistantReply(trimmed);
      final diagnosis = _geminiService.buildTroubleshootingMessage();
      addAiMessage(
        '$fallback\n\n[Offline fallback active]\nReason: ${e.toString().replaceFirst('Exception: ', '')}\n\n$diagnosis',
      );
    }
  }

  String _buildOfflineAssistantReply(String prompt) {
    final lower = prompt.toLowerCase();

    if (lower.contains('sleep')) {
      return 'Sleep guidance:\n'
          '1) Keep the same sleep and wake time daily.\n'
          '2) Avoid caffeine 6-8 hours before bed.\n'
          '3) Reduce screen exposure 30 minutes before sleep.\n'
          '4) Keep your room cool and dark.';
    }

    if (lower.contains('heart') ||
        lower.contains('bp') ||
        lower.contains('pressure')) {
      return 'Heart and blood pressure support:\n'
          '1) Limit salty and highly processed foods.\n'
          '2) Add 20-30 minutes of light to moderate movement.\n'
          '3) Manage stress with slow breathing for 5 minutes.\n'
          '4) Track readings at a consistent time each day.';
    }

    if (lower.contains('diet') ||
        lower.contains('food') ||
        lower.contains('weight')) {
      return 'Nutrition focus:\n'
          '1) Build meals around protein + fiber + healthy fats.\n'
          '2) Keep hydration steady across the day.\n'
          '3) Prefer whole foods over ultra-processed snacks.\n'
          '4) Use consistent meal timing when possible.';
    }

    if (lower.contains('stress') || lower.contains('anxiety')) {
      return 'Stress reset:\n'
          '1) Try box breathing: 4s inhale, 4s hold, 4s exhale, 4s hold.\n'
          '2) Take a short walk outdoors.\n'
          '3) Reduce notifications for 30 minutes.\n'
          '4) Write top 3 tasks only for today.';
    }

    return 'Quick health guidance (offline mode):\n'
        '1) Hydration: aim for steady water intake across the day.\n'
        '2) Movement: add a 15-20 minute walk or light activity today.\n'
        '3) Sleep: keep a consistent bedtime and reduce screens 30 minutes before sleep.\n\n'
        'Your note: "$prompt"\n'
        'For severe symptoms (chest pain, breathing issues, fainting), seek emergency care immediately.';
  }

  void addAiMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(text: trimmed, role: ChatRole.ai),
      ],
    );
  }
}

enum ChatRole { user, ai }

class ChatMessage {
  const ChatMessage({required this.text, required this.role});

  final String text;
  final ChatRole role;
}
