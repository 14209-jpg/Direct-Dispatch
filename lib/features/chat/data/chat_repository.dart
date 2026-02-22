import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../domain/message_model.dart';

class ChatRepository {
  final FirebaseFirestore _db;
  ChatRepository(this._db);

  CollectionReference get _convs =>
      _db.collection(AppConstants.conversationsCollection);

  CollectionReference _msgs(String convId) =>
      _convs.doc(convId).collection(AppConstants.messagesCollection);

  // ── Create conversation tied to a request ─────────────────
  Future<String> createConversation({
    required String requestId,
    required List<String> participantIds,
  }) async {
    final doc = _convs.doc();
    await doc.set({
      'id': doc.id,
      'requestId': requestId,
      'participantIds': participantIds,
      'lastMessage': '',
      'lastMessageAt': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  // ── Add admin to conversation when they first open it ─────
  Future<void> ensureParticipant(String convId, String userId) =>
      _convs.doc(convId).update({
        'participantIds': FieldValue.arrayUnion([userId]),
      });

  // ── Real-time message stream ───────────────────────────────
  Stream<List<Message>> watchMessages(String convId) => _msgs(convId)
      .orderBy('createdAt', descending: false)
      .limitToLast(AppConstants.messagesPageSize)
      .snapshots()
      .map((s) => s.docs.map(Message.fromFirestore).toList());

  // ── Send a text message ────────────────────────────────────
  Future<void> sendMessage({
    required String convId,
    required String senderId,
    required String senderName,
    required String senderRole,
    required String body,
  }) async {
    final ref = _msgs(convId).doc();
    await ref.set({
      'id': ref.id,
      'conversationId': convId,
      'senderId': senderId,
      'senderName': senderName,
      'senderRole': senderRole,
      'body': body,
      'readBy': [senderId],
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Update conversation preview
    await _convs.doc(convId).update({
      'lastMessage': body.length > 60 ? '${body.substring(0, 60)}…' : body,
      'lastMessageAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Mark all unread messages as read ──────────────────────
  Future<void> markAllRead(String convId, String userId) async {
    final unread = await _msgs(convId)
        .where('readBy', whereNotIn: [
          [userId]
        ])
        .get();
    final batch = _db.batch();
    for (final doc in unread.docs) {
      batch.update(doc.reference, {
        'readBy': FieldValue.arrayUnion([userId]),
      });
    }
    await batch.commit();
  }
}

final chatRepositoryProvider = Provider<ChatRepository>(
    (ref) => ChatRepository(ref.watch(firestoreProvider)));