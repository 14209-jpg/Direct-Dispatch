import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../auth/presentation/auth_provider.dart';
import '../domain/service_request_model.dart';
import 'requests_provider.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends ConsumerState<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  // Tab definitions: label + status filter (null = all)
  final _tabDefs = const [
    ('All', null),
    ('Pending', 'pending'),
    ('Active', null), // active = reviewing|confirmed|dispatched|in_progress
    ('Done', 'completed'),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: _tabDefs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allAsync = ref.watch(allRequestsProvider);
    final pendingCount =
        ref.watch(pendingRequestsProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          if (pendingCount > 0)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Badge(
                label: Text('$pendingCount'),
                child: const Icon(Icons.notifications_outlined),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: _tabDefs.map((t) => Tab(text: t.$1)).toList(),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
        ),
      ),
      body: allAsync.when(
        data: (all) => TabBarView(
          controller: _tabs,
          children: [
            // All
            _RequestList(requests: all),
            // Pending
            _RequestList(
                requests:
                    all.where((r) => r.status == 'pending').toList()),
            // Active
            _RequestList(
                requests: all
                    .where((r) => [
                          'reviewing',
                          'confirmed',
                          'dispatched',
                          'in_progress'
                        ].contains(r.status))
                    .toList()),
            // Done
            _RequestList(
                requests:
                    all.where((r) => r.status == 'completed').toList()),
          ],
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

class _RequestList extends StatelessWidget {
  const _RequestList({required this.requests});
  final List<ServiceRequest> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text('Nothing here', style: TextStyle(color: Colors.grey)),
        ]),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _AdminRequestCard(request: requests[i]),
    );
  }
}

class _AdminRequestCard extends StatelessWidget {
  const _AdminRequestCard({required this.request});
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
              Row(children: [
                Expanded(
                  child: Text(request.serviceType,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color),
                  ),
                  child: Text(
                    statusLabel(request.status).toUpperCase(),
                    style: TextStyle(
                        color: color,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5),
                  ),
                ),
              ]),
              const SizedBox(height: 6),
              // Customer name + phone
              Row(children: [
                const Icon(Icons.person_outline,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text('${request.customerName} · ${request.customerPhone}',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13)),
              ]),
              const SizedBox(height: 4),
              // Address
              Row(children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Colors.grey),
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
              // Time
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
              // Chat badge
              if (request.conversationId?.isNotEmpty ?? false)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 14,
                        color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 4),
                    Text('Tap to open chat',
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