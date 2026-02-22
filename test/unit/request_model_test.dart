import 'package:direct_dispatch/core/constants/app_constants.dart';
import 'package:direct_dispatch/features/requests/domain/service_request_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ServiceRequest model', () {
    test('creates with required fields', () {
      final req = ServiceRequest(
        id: 'req_001',
        customerId: 'user_001',
        customerName: 'John Doe',
        customerPhone: '+1234567890',
        serviceType: 'Plumber',
        description: 'Fix leaking kitchen pipe',
        address: '123 Main St',
        status: AppConstants.statusPending,
      );

      expect(req.id, equals('req_001'));
      expect(req.serviceType, equals('Plumber'));
      expect(req.status, equals('pending'));
      expect(req.conversationId, isNull);
    });

    test('copyWith updates only specified fields', () {
      final req = ServiceRequest(
        id: 'req_002',
        customerId: 'user_001',
        customerName: 'Jane',
        customerPhone: '+9876543210',
        serviceType: 'Electrician',
        description: 'Fix socket',
        address: '456 Oak Ave',
        status: AppConstants.statusPending,
      );

      final updated = req.copyWith(
        status: AppConstants.statusReviewing,
        adminNotes: 'Customer confirmed 1 electrician needed',
      );

      expect(updated.status, equals('reviewing'));
      expect(updated.adminNotes, equals('Customer confirmed 1 electrician needed'));
      expect(updated.serviceType, equals('Electrician')); // unchanged
      expect(updated.customerPhone, equals('+9876543210')); // unchanged
    });

    test('statusLabel returns human-readable text', () {
      expect(statusLabel('pending'), equals('Pending Review'));
      expect(statusLabel('reviewing'), equals('Under Review'));
      expect(statusLabel('confirmed'), equals('Confirmed'));
      expect(statusLabel('dispatched'), equals('Workers Dispatched'));
      expect(statusLabel('in_progress'), equals('In Progress'));
      expect(statusLabel('completed'), equals('Completed'));
      expect(statusLabel('cancelled'), equals('Cancelled'));
    });

    test('serializes to JSON correctly', () {
      final req = ServiceRequest(
        id: 'req_003',
        customerId: 'user_001',
        customerName: 'Bob',
        customerPhone: '+1111111111',
        serviceType: 'Cleaner',
        description: 'Deep clean 3-bed house',
        address: '789 Pine Rd',
        status: AppConstants.statusPending,
        numberOfWorkers: 2,
      );

      final json = req.toJson();
      expect(json['serviceType'], equals('Cleaner'));
      expect(json['numberOfWorkers'], equals(2));
      expect(json['status'], equals('pending'));
    });
  });
}