import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_provider.dart';
import '../data/chat_repository.dart';
import '../domain/message_model.dart';

final messagesProvider =
    StreamProvider.family<List<Message>, String>((ref, convId) =>
        ref.watch(chatRepositoryProvider).watchMessages(convId));

class ChatNotifier extends StateNotifier<AsyncValue<void>> {
  final ChatRepository _repo;
  final String convId;
  final String senderId;
  final String senderName;
  final String senderRole;

  ChatNotifier(this._repo,
      {required this.convId,
      required this.senderId,
      required this.senderName,
      required this.senderRole})
      : super(const AsyncValue.data(null));

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.sendMessage(
          convId: convId,
          senderId: senderId,
          senderName: senderName,
          senderRole: senderRole,
          body: text.trim(),
        ));
  }
}

final chatNotifierProvider = StateNotifierProvider.family<ChatNotifier,
    AsyncValue<void>, String>((ref, convId) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  return ChatNotifier(
    ref.watch(chatRepositoryProvider),
    convId: convId,
    senderId: user?.id ?? '',
    senderName: user?.name ?? 'Unknown',
    senderRole: user?.role ?? 'customer',
  );
});