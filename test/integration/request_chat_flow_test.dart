import 'package:direct_dispatch/core/constants/app_constants.dart';
import 'package:direct_dispatch/features/chat/data/chat_repository.dart';
import 'package:direct_dispatch/features/requests/data/requests_repository.dart';
import 'package:direct_dispatch/features/requests/domain/service_request_model.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Request → Conversation → Chat integration', () {
    late FakeFirebaseFirestore fakeDb;
    late ChatRepository chatRepo;
    late RequestsRepository requestRepo;

    setUp(() {
      fakeDb = FakeFirebaseFirestore();
      chatRepo = ChatRepository(fakeDb);
      requestRepo = RequestsRepository(fakeDb, chatRepo);
    });

    test('createRequest auto-creates a conversation', () async {
      final req = await requestRepo.createRequest(
        customerId: 'customer_1',
        customerName: 'Alice Smith',
        customerPhone: '+1234567890',
        serviceType: 'Plumber',
        description: 'Leaking pipe under kitchen sink',
        address: '123 Main St, Springfield',
      );

      expect(req.id, isNotEmpty);
      expect(req.conversationId, isNotEmpty);
      expect(req.status, equals(AppConstants.statusPending));
    });

    test('customer can send message in auto-created conversation', () async {
      final req = await requestRepo.createRequest(
        customerId: 'customer_1',
        customerName: 'Alice',
        customerPhone: '+1234567890',
        serviceType: 'Electrician',
        description: 'Sparking socket in bedroom',
        address: '456 Oak Ave',
      );

      await chatRepo.sendMessage(
        convId: req.conversationId!,
        senderId: 'customer_1',
        senderName: 'Alice',
        senderRole: 'customer',
        body: 'Hi, I need an electrician urgently!',
      );

      final messages =
          await chatRepo.watchMessages(req.conversationId!).first;

      expect(messages.length, equals(1));
      expect(messages.first.body, contains('electrician'));
      expect(messages.first.senderRole, equals('customer'));
    });

    test('admin reply appears in same conversation', () async {
      final req = await requestRepo.createRequest(
        customerId: 'customer_2',
        customerName: 'Bob',
        customerPhone: '+9876543210',
        serviceType: 'Painter',
        description: 'Paint 2 bedroom walls',
        address: '789 Pine Rd',
      );

      // Customer message
      await chatRepo.sendMessage(
        convId: req.conversationId!,
        senderId: 'customer_2',
        senderName: 'Bob',
        senderRole: 'customer',
        body: 'When can you send someone?',
      );

      // Admin reply
      await chatRepo.sendMessage(
        convId: req.conversationId!,
        senderId: 'admin_1',
        senderName: 'Admin',
        senderRole: 'admin',
        body: 'Hi Bob! We can send 2 painters tomorrow morning.',
      );

      final messages =
          await chatRepo.watchMessages(req.conversationId!).first;

      expect(messages.length, equals(2));
      expect(messages[0].senderRole, equals('customer'));
      expect(messages[1].senderRole, equals('admin'));
      expect(messages[1].body, contains('tomorrow'));
    });

    test('admin can update request status', () async {
      final req = await requestRepo.createRequest(
        customerId: 'customer_3',
        customerName: 'Carol',
        customerPhone: '+5551234567',
        serviceType: 'Construction / Labourer',
        description: 'Need 3 labourers for 1 day of construction',
        address: '101 Building Site Rd',
      );

      await requestRepo.updateStatus(
          req.id, AppConstants.statusReviewing);

      final updated = await requestRepo.getRequest(req.id);
      expect(updated.status, equals('reviewing'));
    });

    test('full lifecycle: pending → reviewing → confirmed → dispatched → completed',
        () async {
      final req = await requestRepo.createRequest(
        customerId: 'customer_4',
        customerName: 'Dave',
        customerPhone: '+1112223333',
        serviceType: 'Plumber',
        description: 'Blocked drain',
        address: '222 Water St',
      );

      final statuses = [
        AppConstants.statusReviewing,
        AppConstants.statusConfirmed,
        AppConstants.statusDispatched,
        AppConstants.statusInProgress,
        AppConstants.statusCompleted,
      ];

      for (final status in statuses) {
        await requestRepo.updateStatus(req.id, status);
        final updated = await requestRepo.getRequest(req.id);
        expect(updated.status, equals(status));
      }
    });
  });
}