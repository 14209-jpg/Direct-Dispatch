import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_provider.dart';
import '../data/chat_repository.dart';
import 'chat_input_bar.dart';
import 'chat_provider.dart';
import 'message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    super.key,
    required this.requestId,
    required this.conversationId,
  });
  final String requestId;
  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    // Ensure admin is added as participant and mark messages read
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) return;
      final repo = ref.read(chatRepositoryProvider);
      if (user.role == 'admin') {
        await repo.ensureParticipant(widget.conversationId, user.id);
      }
      await repo.markAllRead(widget.conversationId, user.id);
    });
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final messagesAsync =
        ref.watch(messagesProvider(widget.conversationId));
    final notifier =
        ref.read(chatNotifierProvider(widget.conversationId).notifier);

    // Auto-scroll when new messages arrive
    ref.listen(messagesProvider(widget.conversationId), (_, __) {
      Future.delayed(
          const Duration(milliseconds: 100), _scrollToBottom);
    });

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.role == 'admin'
                ? 'Customer Chat'
                : 'Chat with Admin'),
            Text(
              'Request #${widget.requestId.substring(0, 8)}',
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Messages ───────────────────────────────────────
          Expanded(
            child: messagesAsync.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 56, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No messages yet.\nStart the conversation!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  controller: _scrollCtrl,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 12),
                  itemCount: messages.length,
                  itemBuilder: (_, i) {
                    final msg = messages[i];
                    final isMe = msg.senderId == user?.id;
                    // Date separator
                    final showDate = i == 0 ||
                        !_sameDay(
                            messages[i - 1].createdAt, msg.createdAt);
                    return Column(
                      children: [
                        if (showDate && msg.createdAt != null)
                          _DateSeparator(date: msg.createdAt!),
                        MessageBubble(message: msg, isMe: isMe),
                      ],
                    );
                  },
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Center(child: Text('Failed to load messages: $e')),
            ),
          ),

          // ── Input bar ──────────────────────────────────────
          ChatInputBar(
            onSend: (text) => notifier.send(text),
          ),
        ],
      ),
    );
  }

  bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}

class _DateSeparator extends StatelessWidget {
  const _DateSeparator({required this.date});
  final DateTime date;

  String _label() {
    final now = DateTime.now();
    final diff = now.difference(date).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(_label(),
                style: const TextStyle(
                    fontSize: 12, color: Colors.grey)),
          ),
          const Expanded(child: Divider()),
        ]),
      );
}