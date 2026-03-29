import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatStateProvider = StateNotifierProvider<ChatStateNotifier, ChatState>((
  ref,
) {
  return ChatStateNotifier();
});

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
          text: 'Hi, I am Aura AI. Ask me anything about your health trends.',
          role: ChatRole.ai,
        ),
      ],
    );
  }
}

class ChatStateNotifier extends StateNotifier<ChatState> {
  ChatStateNotifier() : super(ChatState.initial());

  void sendUserMessage(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final updated = [
      ...state.messages,
      ChatMessage(text: trimmed, role: ChatRole.user),
    ];
    state = state.copyWith(messages: updated);

    addAiMessage(_buildAiResponse(trimmed));
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

  String _buildAiResponse(String prompt) {
    return 'Neural insight: "$prompt" can be improved by consistent hydration, '
        'a 20-minute wind-down, and steady activity pacing through the day.';
  }
}

enum ChatRole { user, ai }

class ChatMessage {
  const ChatMessage({required this.text, required this.role});

  final String text;
  final ChatRole role;
}
