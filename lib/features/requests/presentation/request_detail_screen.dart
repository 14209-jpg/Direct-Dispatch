import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/requests_repository.dart';
import '../domain/service_request_model.dart';
import 'requests_provider.dart';

class RequestDetailScreen extends ConsumerWidget {
  const RequestDetailScreen({super.key, required this.requestId});
  final String requestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reqAsync = ref.watch(requestDetailProvider(requestId));
    final user = ref.watch(currentUserProvider).valueOrNull;
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: reqAsync.when(
        data: (req) => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Status hero ──────────────────────────────
              _StatusHero(request: req),
              const SizedBox(height: 16),

              // ── Details card ─────────────────────────────
              _InfoCard(children: [
                _InfoRow(icon: Icons.build_outlined,
                    label: 'Service', value: req.serviceType),
                _InfoRow(icon: Icons.location_on_outlined,
                    label: 'Address', value: req.address),
                _InfoRow(icon: Icons.phone_outlined,
                    label: 'Phone', value: req.customerPhone),
                if (req.createdAt != null)
                  _InfoRow(icon: Icons.access_time,
                      label: 'Requested',
                      value: DateFormatter.full(req.createdAt!)),
                if (req.numberOfWorkers != null)
                  _InfoRow(icon: Icons.people_outline,
                      label: 'Workers',
                      value: '${req.numberOfWorkers} assigned'),
                if (req.scheduledAt != null)
                  _InfoRow(icon: Icons.calendar_today_outlined,
                      label: 'Scheduled',
                      value: DateFormatter.full(req.scheduledAt!)),
              ]),
              const SizedBox(height: 12),

              // ── Description ──────────────────────────────
              _SectionCard(
                title: 'Description',
                child: Text(req.description,
                    style: const TextStyle(height: 1.5)),
              ),

              // ── Admin notes (if any) ─────────────────────
              if (req.adminNotes?.isNotEmpty ?? false) ...[
                const SizedBox(height: 12),
                _SectionCard(
                  title: 'Admin Notes',
                  titleColor: Theme.of(context).colorScheme.primary,
                  child: Text(req.adminNotes!,
                      style: const TextStyle(height: 1.5)),
                ),
              ],

              // ── Cash payment reminder ─────────────────────
              if (req.status != 'cancelled' &&
                  req.status != 'completed') ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.green.shade300),
                  ),
                  child: const Row(children: [
                    Icon(Icons.payments_outlined,
                        color: Colors.green),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Payment is cash on completion. '
                        'No online payment required.',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
              ],

              const SizedBox(height: 20),

              // ── Open chat button ─────────────────────────
              if (req.conversationId?.isNotEmpty ?? false)
                ElevatedButton.icon(
                  onPressed: () => context.push(
                    '/request/$requestId/chat'
                    '?conversationId=${req.conversationId}',
                  ),
                  icon: const Icon(Icons.chat_outlined),
                  label: const Text('Chat with Admin'),
                ),

              // ── Admin action buttons ─────────────────────
              if (isAdmin) ...[
                const SizedBox(height: 12),
                _AdminActions(request: req),
              ],
            ],
          ),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}

// ── Status hero banner ──────────────────────────────────────
class _StatusHero extends StatelessWidget {
  const _StatusHero({required this.request});
  final ServiceRequest request;

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(request.status);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withOpacity(0.2),
            child: Icon(_statusIcon(request.status), color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(statusLabel(request.status),
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Text(_statusDescription(request.status),
                    style: const TextStyle(
                        color: Colors.black54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _statusIcon(String s) => switch (s) {
        'pending'     => Icons.hourglass_empty,
        'reviewing'   => Icons.search,
        'confirmed'   => Icons.thumb_up_outlined,
        'dispatched'  => Icons.directions_car_outlined,
        'in_progress' => Icons.construction,
        'completed'   => Icons.check_circle_outline,
        'cancelled'   => Icons.cancel_outlined,
        _             => Icons.info_outline,
      };

  String _statusDescription(String s) => switch (s) {
        'pending'     => 'Waiting for admin to review your request.',
        'reviewing'   => 'Admin is reviewing your request.',
        'confirmed'   => 'Details confirmed. Workers being sourced.',
        'dispatched'  => 'Workers are on their way to your location.',
        'in_progress' => 'Work is currently in progress.',
        'completed'   => 'Job completed. Thank you!',
        'cancelled'   => 'This request has been cancelled.',
        _             => '',
      };
}

// ── Admin action buttons ─────────────────────────────────────
class _AdminActions extends ConsumerStatefulWidget {
  const _AdminActions({required this.request});
  final ServiceRequest request;

  @override
  ConsumerState<_AdminActions> createState() => _AdminActionsState();
}

class _AdminActionsState extends ConsumerState<_AdminActions> {
  final _notesCtrl = TextEditingController();
  final _workersCtrl = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _notesCtrl.text = widget.request.adminNotes ?? '';
    _workersCtrl.text =
        widget.request.numberOfWorkers?.toString() ?? '';
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _workersCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveDetails() async {
    setState(() => _saving = true);
    try {
      await ref.read(requestsRepositoryProvider).saveAdminDetails(
            id: widget.request.id,
            notes: _notesCtrl.text.trim(),
            workers: int.tryParse(_workersCtrl.text.trim()),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Details saved')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _setStatus(String status) async {
    await ref
        .read(requestsRepositoryProvider)
        .updateStatus(widget.request.id, status);
    ref.invalidate(requestDetailProvider(widget.request.id));
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.request.status;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Admin Controls',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),

        // Notes
        TextFormField(
          controller: _notesCtrl,
          decoration: const InputDecoration(
            labelText: 'Internal notes',
            hintText: 'Details gathered from customer call…',
            alignLabelWithHint: true,
          ),
          maxLines: 3,
        ),
        const SizedBox(height: 10),

        // Worker count
        TextFormField(
          controller: _workersCtrl,
          decoration: const InputDecoration(
            labelText: 'Number of workers to send',
            prefixIcon: Icon(Icons.people_outline),
          ),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),

        OutlinedButton(
          onPressed: _saving ? null : _saveDetails,
          child: _saving
              ? const SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Save Notes & Worker Count'),
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),

        // Status progression buttons
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (s == 'pending')
              _ActionBtn(
                label: 'Mark Reviewing',
                color: Colors.blue,
                icon: Icons.search,
                onTap: () => _setStatus('reviewing'),
              ),
            if (s == 'reviewing')
              _ActionBtn(
                label: 'Confirm & Get Workers',
                color: Colors.purple,
                icon: Icons.thumb_up_outlined,
                onTap: () => _setStatus('confirmed'),
              ),
            if (s == 'confirmed')
              _ActionBtn(
                label: 'Mark Dispatched',
                color: Colors.teal,
                icon: Icons.directions_car_outlined,
                onTap: () => _setStatus('dispatched'),
              ),
            if (s == 'dispatched')
              _ActionBtn(
                label: 'Mark In Progress',
                color: Colors.orange,
                icon: Icons.construction,
                onTap: () => _setStatus('in_progress'),
              ),
            if (s == 'in_progress')
              _ActionBtn(
                label: '✅ Mark Completed',
                color: Colors.green,
                icon: Icons.check_circle_outline,
                onTap: () => _setStatus('completed'),
              ),
            if (s != 'completed' && s != 'cancelled')
              _ActionBtn(
                label: 'Cancel Request',
                color: Colors.red,
                icon: Icons.cancel_outlined,
                onTap: () => _setStatus('cancelled'),
              ),
          ],
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  const _ActionBtn({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          minimumSize: const Size(0, 44),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
      );
}

// ── Shared UI helpers ────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children)),
      );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 17, color: Colors.grey),
            const SizedBox(width: 8),
            SizedBox(
                width: 80,
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13))),
            Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      );
}

class _SectionCard extends StatelessWidget {
  const _SectionCard(
      {required this.title, required this.child, this.titleColor});
  final String title;
  final Widget child;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: titleColor ??
                          Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 8),
              child,
            ],
          ),
        ),
      );
}