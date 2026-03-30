// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'chat_state.dart';

class NeuralChatScreen extends ConsumerStatefulWidget {
  const NeuralChatScreen({super.key});

  @override
  ConsumerState<NeuralChatScreen> createState() => _NeuralChatScreenState();
}

class _NeuralChatScreenState extends ConsumerState<NeuralChatScreen> {
  static const double _kPadding = 20;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _pulseForward = true;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatStateProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const _ChatTopBar(),
            const _EmergencyDisclaimerBanner(),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(
                  _kPadding,
                  16,
                  _kPadding,
                  140,
                ),
                itemCount: chatState.messages.length,
                itemBuilder: (context, index) {
                  final message = chatState.messages[index];
                  return _ChatBubble(message: message);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _kPadding),
        child: _InputComposer(
          controller: _controller,
          pulseForward: _pulseForward,
          onPulseCycle: () {
            if (!mounted) {
              return;
            }
            setState(() {
              _pulseForward = !_pulseForward;
            });
          },
          onSend: _sendMessage,
        ),
      ),
      backgroundColor: const Color(0xFF0B0E11),
    );
  }

  void _sendMessage() async {
    final text = _controller.text;
    _controller.clear();

    // Scroll immediately after clearing input
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });

    // Send message to AI (async operation)
    await ref.read(chatStateProvider.notifier).sendUserMessage(text);

    // Scroll again after AI responds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) {
      return;
    }
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 120,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }
}

class _ChatTopBar extends StatelessWidget {
  const _ChatTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.go('/dashboard'),
            icon: const Icon(Icons.arrow_back_rounded),
            color: Colors.white,
            tooltip: 'Back to dashboard',
          ),
          const SizedBox(width: 4),
          Text(
            'AI Doctor Chat',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyDisclaimerBanner extends StatelessWidget {
  const _EmergencyDisclaimerBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF4D4D).withOpacity(0.16),
            const Color(0xFFFFA24D).withOpacity(0.12),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFF7070).withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            LucideIcons.shieldAlert,
            color: Color(0xFFFFB3B3),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Emergency Disclaimer: Aura AI is not a substitute for emergency care. '
              'Call local emergency services for urgent symptoms.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.94),
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: isUser
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF00D8E6), Color(0xFF00F2FF)],
                    )
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(0.14),
                        Colors.white.withOpacity(0.05),
                      ],
                    ),
              border: Border.all(
                color: isUser
                    ? const Color(0xFF00FFFF).withOpacity(0.45)
                    : Colors.white.withOpacity(0.22),
                width: 1,
              ),
              boxShadow: isUser
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00F2FF).withOpacity(0.32),
                        blurRadius: 16,
                        spreadRadius: -4,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.14),
                        blurRadius: 10,
                        spreadRadius: -4,
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: isUser ? 0 : 12,
                  sigmaY: isUser ? 0 : 12,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Text(
                    message.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      height: 1.35,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputComposer extends StatelessWidget {
  const _InputComposer({
    required this.controller,
    required this.pulseForward,
    required this.onPulseCycle,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool pulseForward;
  final VoidCallback onPulseCycle;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white.withOpacity(0.08),
            border: Border.all(
              color: const Color(0xFF00F2FF).withOpacity(0.62),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F2FF).withOpacity(0.32),
                blurRadius: 18,
                spreadRadius: -6,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask Aura AI...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.65)),
                    border: InputBorder.none,
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => onSend(),
                ),
              ),
              const SizedBox(width: 8),
              TweenAnimationBuilder<double>(
                tween: Tween<double>(
                  begin: pulseForward ? 0.84 : 1,
                  end: pulseForward ? 1 : 0.84,
                ),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeInOut,
                onEnd: onPulseCycle,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF00F2FF).withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF00F2FF,
                            ).withOpacity(0.45 * value),
                            blurRadius: 12,
                            spreadRadius: -2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        LucideIcons.mic,
                        size: 18,
                        color: Color(0xFF90FBFF),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onSend,
                icon: const Icon(LucideIcons.send),
                color: const Color(0xFF00F2FF),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
