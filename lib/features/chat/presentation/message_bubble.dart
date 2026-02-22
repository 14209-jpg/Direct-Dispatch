import 'package:flutter/material.dart';

import '../../../core/utils/date_formatter.dart';
import '../domain/message_model.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  final Message message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Admin messages get a slightly different accent so it's clear who's talking
    final bubbleColor = isMe
        ? scheme.primary
        : message.senderRole == 'admin'
            ? const Color(0xFF1B5E20)   // dark green for admin
            : scheme.surfaceVariant;

    final textColor = isMe || message.senderRole == 'admin'
        ? Colors.white
        : scheme.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 6,
        left: isMe ? 48 : 0,
        right: isMe ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar (other side only)
          if (!isMe) ...[
            CircleAvatar(
              radius: 15,
              backgroundColor: message.senderRole == 'admin'
                  ? const Color(0xFF1B5E20)
                  : scheme.primary,
              child: Text(
                message.senderName.isNotEmpty
                    ? message.senderName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 6),
          ],

          // Bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Sender name (other side only)
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${message.senderName} '
                        '(${message.senderRole == 'admin' ? 'Admin' : 'You'})',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: textColor.withOpacity(0.85),
                        ),
                      ),
                    ),

                  // Message body
                  Text(
                    message.body,
                    style:
                        TextStyle(color: textColor, fontSize: 15, height: 1.4),
                  ),

                  // Time + read receipt
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message.createdAt != null
                            ? DateFormatter.chatTime(message.createdAt!)
                            : '',
                        style: TextStyle(
                            fontSize: 10,
                            color: textColor.withOpacity(0.6)),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 4),
                        Icon(
                          message.readBy.length > 1
                              ? Icons.done_all
                              : Icons.done,
                          size: 13,
                          color: textColor.withOpacity(0.6),
                        ),
                      ],
                    ],
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