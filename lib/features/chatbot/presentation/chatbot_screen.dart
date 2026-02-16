import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/tokai_scaffold.dart';
import '../domain/chat_message.dart';
import '../providers/chatbot_providers.dart';

class ChatbotScreen extends ConsumerStatefulWidget {
  const ChatbotScreen({super.key});

  @override
  ConsumerState<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends ConsumerState<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send([String? override]) async {
    final text = override ?? _controller.text;
    _controller.clear();
    await ref.read(chatbotControllerProvider.notifier).send(text);
    if (_scroll.hasClients) {
      await Future.delayed(const Duration(milliseconds: 60));
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatbotControllerProvider);

    return TokaiScaffold(
      title: 'سألنا',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              itemCount: state.messages.length + (state.isLoading ? 1 : 0),
              itemBuilder: (context, i) {
                if (state.isLoading && i == state.messages.length) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  );
                }

                final m = state.messages[i];
                final isUser = m.role == ChatRole.user;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Align(
                    alignment: isUser ? Alignment.centerLeft : Alignment.centerRight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: isUser ? const Color(0xFFEDEDED) : const Color(0xFFFFF3C4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        child: Text(m.text),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (state.quickReplies.isNotEmpty)
            SizedBox(
              height: 54,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemCount: state.quickReplies.length,
                itemBuilder: (context, i) {
                  final t = state.quickReplies[i];
                  return OutlinedButton(
                    onPressed: () => _send(t),
                    child: Text(t),
                  );
                },
              ),
            ),
          const Divider(height: 1),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _send('تواصل مع الدعم'),
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(
                        hintText: 'اكتب رسالتك',
                        isDense: true,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: state.isLoading ? null : _send,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
