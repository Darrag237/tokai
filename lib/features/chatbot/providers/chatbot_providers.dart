import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/errors/app_exception.dart';
import '../../../core/services/firebase_providers.dart';
import '../data/faq_repository.dart';
import '../domain/chat_message.dart';

final faqRepositoryProvider = Provider<FaqRepository>((ref) {
  return FaqRepository(ref.watch(firestoreProvider));
});

class ChatbotState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final List<String> quickReplies;

  const ChatbotState({
    required this.messages,
    this.isLoading = false,
    this.error,
    this.quickReplies = const [],
  });

  ChatbotState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    List<String>? quickReplies,
  }) {
    return ChatbotState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      quickReplies: quickReplies ?? this.quickReplies,
    );
  }
}

class ChatbotController extends StateNotifier<ChatbotState> {
  ChatbotController(this.ref)
      : super(
          ChatbotState(
            messages: [
              ChatMessage(
                id: const Uuid().v4(),
                role: ChatRole.bot,
                text: 'اهلاً بيك 👋 اقدر اساعدك ازاي؟',
                createdAt: DateTime.now(),
              ),
            ],
            quickReplies: const [
              'طلب توكتوك',
              'المحفظة',
              'العروض',
              'الحساب',
              'زر الطوارئ',
              'تواصل مع الدعم',
            ],
          ),
        );

  final Ref ref;
  final _uuid = const Uuid();

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final next = [...state.messages]
      ..add(ChatMessage(id: _uuid.v4(), role: ChatRole.user, text: trimmed, createdAt: now));

    state = state.copyWith(messages: next, isLoading: true, error: null, quickReplies: const []);

    try {
      final faq = await ref.read(faqRepositoryProvider).searchBest(trimmed);
      if (faq != null) {
        _appendBot(faq.answer);
        state = state.copyWith(
          isLoading: false,
          quickReplies: faq.tags.isNotEmpty ? faq.tags.take(6).toList() : _defaultQuickReplies,
        );
      } else {
        _appendBot('مش قادر أحدد من سؤالك… هل تقصد الحجز ولا المحفظة؟');
        state = state.copyWith(isLoading: false, quickReplies: _defaultQuickReplies);
      }
    } on AppException catch (e) {
      _appendBot('حصلت مشكلة في تحميل المعلومات. جرب مرة تانية.');
      state = state.copyWith(isLoading: false, error: e.message, quickReplies: _defaultQuickReplies);
    } catch (_) {
      _appendBot('حصلت مشكلة غير متوقعة.');
      state = state.copyWith(isLoading: false, error: 'unexpected', quickReplies: _defaultQuickReplies);
    }
  }

  void _appendBot(String text) {
    final next = [...state.messages]
      ..add(ChatMessage(id: _uuid.v4(), role: ChatRole.bot, text: text, createdAt: DateTime.now()));
    state = state.copyWith(messages: next);
  }

  static const _defaultQuickReplies = [
    'الحجز',
    'المحفظة',
    'العروض',
    'الحساب',
    'زر الطوارئ',
    'تواصل مع الدعم',
  ];
}

final chatbotControllerProvider = StateNotifierProvider<ChatbotController, ChatbotState>((ref) {
  return ChatbotController(ref);
});
