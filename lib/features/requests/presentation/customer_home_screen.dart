import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/service_request_model.dart';
import 'requests_provider.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).valueOrNull;
    final requestsAsync = ref.watch(customerRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, ${user?.name.split(' ').first ?? ''}! 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/new-request'),
        icon: const Icon(Icons.add),
        label: const Text('New Request'),
      ),
      body: requestsAsync.when(
        data: (requests) {
          if (requests.isEmpty) {
            return _EmptyState(
              icon: Icons.handyman_outlined,
              title: 'No requests yet',
              subtitle: 'Tap "+ New Request" to get started.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(customerRequestsProvider),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: requests.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) =>
                  _RequestCard(request: requests[i]),
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) =>
            Center(child: Text('Something went wrong:\n$e')),
      ),
    );
  }
}

// ── Shared request card ──────────────────────────────────────
class _RequestCard extends StatelessWidget {
  const _RequestCard({required this.request});
  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(request.status);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => context.push('/request/${request.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service type + status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      request.serviceType,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _StatusBadge(status: request.status),
                ],
              ),
              const SizedBox(height: 6),
              // Address
              Row(children: [
                const Icon(Icons.location_on_outlined,
                    size: 15, color: Colors.grey),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(request.address,
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
              const SizedBox(height: 4),
              // Date
              Row(children: [
                const Icon(Icons.access_time,
                    size: 13, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  request.createdAt != null
                      ? DateFormatter.full(request.createdAt!)
                      : '',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey),
                ),
              ]),
              // Chat indicator
              if (request.conversationId != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Text('Chat available',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context)
                                .colorScheme
                                .primary)),
                  ]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Status badge ─────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});
  final String status;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        statusLabel(status).toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState(
      {required this.icon,
      required this.title,
      required this.subtitle});
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center),
          ],
        ),
      );
}