import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/presentation/auth_provider.dart';
import '../data/requests_repository.dart';
import '../domain/service_request_model.dart';

// Customer: only their requests
final customerRequestsProvider =
    StreamProvider<List<ServiceRequest>>((ref) {
  final user = ref.watch(currentUserProvider).valueOrNull;
  if (user == null) return const Stream.empty();
  return ref
      .watch(requestsRepositoryProvider)
      .watchCustomerRequests(user.id);
});

// Admin: all requests (unfiltered)
final allRequestsProvider =
    StreamProvider<List<ServiceRequest>>((ref) =>
        ref.watch(requestsRepositoryProvider).watchAllRequests());

// Admin: pending only (badge count)
final pendingRequestsProvider =
    StreamProvider<List<ServiceRequest>>((ref) => ref
        .watch(requestsRepositoryProvider)
        .watchAllRequests(status: 'pending'));

// Single request detail
final requestDetailProvider =
    FutureProvider.family<ServiceRequest, String>(
        (ref, id) => ref.watch(requestsRepositoryProvider).getRequest(id));