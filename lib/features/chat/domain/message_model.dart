import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_model.freezed.dart';
part 'message_model.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String conversationId,
    required String senderId,
    required String senderName,
    required String senderRole, // 'customer' | 'admin'
    required String body,
    @Default([]) List<String> readBy,
    DateTime? createdAt,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Message.fromJson({
      ...d,
      'id': doc.id,
      'createdAt':
          (d['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
    });
  }
}