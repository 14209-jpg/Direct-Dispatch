import 'package:flutter/material.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend});
  final Future<void> Function(String text) onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _ctrl = TextEditingController();
  bool _hasText = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(
        () => setState(() => _hasText = _ctrl.text.trim().isNotEmpty));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_hasText || _sending) return;
    final text = _ctrl.text.trim();
    _ctrl.clear();
    setState(() => _sending = true);
    try {
      await widget.onSend(text);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send: $e'),
            action: SnackBarAction(
                label: 'Retry', onPressed: () => widget.onSend(text)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
              top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.5)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            // Text field
            Expanded(
              child: TextField(
                controller: _ctrl,
                minLines: 1,
                maxLines: 5,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Type a message…',
                  filled: true,
                  fillColor: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),

            // Send button
            Semantics(
              label: 'Send message',
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: _sending
                    ? const SizedBox(
                        width: 46,
                        height: 46,
                        child: Center(
                          child: SizedBox(
                            width: 22,
                            height: 22,
                            child:
                                CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      )
                    : InkWell(
                        onTap: _hasText ? _send : null,
                        borderRadius: BorderRadius.circular(24),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: _hasText
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey[300],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.send_rounded,
                            color:
                                _hasText ? Colors.white : Colors.grey[500],
                            size: 20,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}