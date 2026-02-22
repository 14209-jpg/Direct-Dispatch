import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_request_model.freezed.dart';
part 'service_request_model.g.dart';

@freezed
class ServiceRequest with _$ServiceRequest {
  const factory ServiceRequest({
    required String id,
    required String customerId,
    required String customerName,
    required String customerPhone,
    required String serviceType,
    required String description,
    required String address,
    required String status,
    String? conversationId,
    // Admin fills these after speaking with customer
    String? adminNotes,
    int? numberOfWorkers,
    DateTime? scheduledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ServiceRequest;

  factory ServiceRequest.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestFromJson(json);

  factory ServiceRequest.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return ServiceRequest.fromJson({
      ...d,
      'id': doc.id,
      'createdAt':
          (d['createdAt'] as Timestamp?)?.toDate().toIso8601String(),
      'updatedAt':
          (d['updatedAt'] as Timestamp?)?.toDate().toIso8601String(),
      'scheduledAt':
          (d['scheduledAt'] as Timestamp?)?.toDate().toIso8601String(),
    });
  }
}

// All service types offered
const kServiceTypes = [
  'Plumber',
  'Electrician',
  'Construction / Labourer',
  'Painter',
  'Carpenter',
  'Cleaner',
  'Mover',
  'Other',
];

// Human-readable status labels
String statusLabel(String status) => switch (status) {
      'pending'     => 'Pending Review',
      'reviewing'   => 'Under Review',
      'confirmed'   => 'Confirmed',
      'dispatched'  => 'Workers Dispatched',
      'in_progress' => 'In Progress',
      'completed'   => 'Completed',
      'cancelled'   => 'Cancelled',
      _             => status,
    };