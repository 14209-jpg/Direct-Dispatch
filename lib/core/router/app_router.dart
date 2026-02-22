import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/auth_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/requests/presentation/admin_dashboard_screen.dart';
import '../../features/requests/presentation/create_request_screen.dart';
import '../../features/requests/presentation/customer_home_screen.dart';
import '../../features/requests/presentation/request_detail_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../core/constants/app_constants.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final user = authAsync.valueOrNull;
      final onLogin = state.matchedLocation == '/login';
      if (user == null && !onLogin) return '/login';
      if (user != null && onLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (_, __) => const _HomeGate(),
      ),
      GoRoute(
        path: '/new-request',
        builder: (_, __) => const CreateRequestScreen(),
      ),
      GoRoute(
        path: '/request/:id',
        builder: (_, state) =>
            RequestDetailScreen(requestId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'chat',
            builder: (_, state) => ChatScreen(
              requestId: state.pathParameters['id']!,
              conversationId:
                  state.uri.queryParameters['conversationId'] ?? '',
            ),
          ),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      body: Center(child: Text('Page not found: ${state.error}')),
    ),
  );
});

/// Sends user to the right home screen based on their role.
class _HomeGate extends ConsumerWidget {
  const _HomeGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    return userAsync.when(
      data: (user) {
        if (user == null) return const LoginScreen();
        return user.role == AppConstants.roleAdmin
            ? const AdminDashboardScreen()
            : const CustomerHomeScreen();
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}