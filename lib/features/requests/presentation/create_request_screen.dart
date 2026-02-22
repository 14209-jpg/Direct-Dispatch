import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../auth/presentation/auth_provider.dart';
import '../data/requests_repository.dart';
import '../domain/service_request_model.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState
    extends ConsumerState<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _serviceType = kServiceTypes.first;
  bool _submitting = false;

  @override
  void dispose() {
    _descCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);

    try {
      final user = ref.read(currentUserProvider).valueOrNull;
      if (user == null) throw Exception('Not signed in');

      final req = await ref
          .read(requestsRepositoryProvider)
          .createRequest(
            customerId: user.id,
            customerName: user.name,
            customerPhone: user.phone,
            serviceType: _serviceType,
            description: _descCtrl.text.trim(),
            address: _addressCtrl.text.trim(),
          );

      if (mounted) {
        // Go to the request detail so customer can see status + chat
        context.pushReplacement('/request/${req.id}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            action: SnackBarAction(label: 'Retry', onPressed: _submit),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Service Request')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── What do you need? ──
              Text('What service do you need?',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: kServiceTypes.map((s) {
                  final selected = s == _serviceType;
                  return ChoiceChip(
                    label: Text(s),
                    selected: selected,
                    onSelected: (_) =>
                        setState(() => _serviceType = s),
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.15),
                    labelStyle: TextStyle(
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selected
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Description ──
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Describe the work',
                  hintText:
                      'e.g. Fix leaking kitchen pipe, approx 1 hour…',
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                validator: (v) => (v?.trim().isEmpty ?? true)
                    ? 'Please describe what you need'
                    : null,
              ),
              const SizedBox(height: 16),

              // ── Address ──
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(
                  labelText: 'Your address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                  hintText: '123 Main St, City',
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Address required' : null,
              ),
              const SizedBox(height: 8),

              // ── Info note ──
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.amber, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Our admin will contact you shortly to confirm details. '
                        'Payment is cash on completion.',
                        style:
                            TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Submit ──
              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                child: _submitting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}