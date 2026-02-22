import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../chat/data/chat_repository.dart';
import '../domain/service_request_model.dart';

class RequestsRepository {
  final FirebaseFirestore _db;
  final ChatRepository _chat;

  RequestsRepository(this._db, this._chat);

  CollectionReference get _col =>
      _db.collection(AppConstants.requestsCollection);

  // ── Customer: watch own requests ──────────────────────────
  Stream<List<ServiceRequest>> watchCustomerRequests(String customerId) =>
      _col
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((s) => s.docs.map(ServiceRequest.fromFirestore).toList());

  // ── Admin: watch all requests (optionally filter by status) ──
  Stream<List<ServiceRequest>> watchAllRequests({String? status}) {
    Query q = _col.orderBy('createdAt', descending: true);
    if (status != null) q = q.where('status', isEqualTo: status);
    return q
        .limit(AppConstants.requestsPageSize)
        .snapshots()
        .map((s) => s.docs.map(ServiceRequest.fromFirestore).toList());
  }

  Future<ServiceRequest> getRequest(String id) async {
    final doc = await _col.doc(id).get();
    return ServiceRequest.fromFirestore(doc);
  }

  // ── Customer: create a new service request ────────────────
  Future<ServiceRequest> createRequest({
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String serviceType,
    required String description,
    required String address,
  }) async {
    final docRef = _col.doc();

    // Auto-create a conversation for admin ↔ customer chat
    final convId = await _chat.createConversation(
      requestId: docRef.id,
      participantIds: [customerId],
    );

    final req = ServiceRequest(
      id: docRef.id,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      serviceType: serviceType,
      description: description,
      address: address,
      status: AppConstants.statusPending,
      conversationId: convId,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await docRef.set({
      ...req.toJson(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return req;
  }

  // ── Admin: update status ───────────────────────────────────
  Future<void> updateStatus(String id, String status) => _col.doc(id).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── Admin: save notes + worker count + schedule ───────────
  Future<void> saveAdminDetails({
    required String id,
    String? notes,
    int? workers,
    DateTime? scheduledAt,
  }) =>
      _col.doc(id).update({
        if (notes != null) 'adminNotes': notes,
        if (workers != null) 'numberOfWorkers': workers,
        if (scheduledAt != null) 'scheduledAt': Timestamp.fromDate(scheduledAt),
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── Admin: mark completed ─────────────────────────────────
  Future<void> markCompleted(String id) => _col.doc(id).update({
        'status': AppConstants.statusCompleted,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ── Admin: cancel ─────────────────────────────────────────
  Future<void> cancel(String id) => _col.doc(id).update({
        'status': AppConstants.statusCancelled,
        'updatedAt': FieldValue.serverTimestamp(),
      });
}

final requestsRepositoryProvider =
    Provider<RequestsRepository>((ref) => RequestsRepository(
          ref.watch(firestoreProvider),
          ref.watch(chatRepositoryProvider),
        ));