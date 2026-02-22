import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/firebase_providers.dart';
import '../data/auth_repository.dart';
import '../domain/user_model.dart';

// Raw Firebase auth stream
final authStateProvider = StreamProvider<User?>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

// Resolved AppUser with role
final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final fireUser = ref.watch(authStateProvider).valueOrNull;
  if (fireUser == null) return null;
  return ref.read(authRepositoryProvider).getCurrentUser();
});

// ── Auth actions notifier ──────────────────────────────────
class AuthNotifier extends StateNotifier<AsyncValue<AppUser?>> {
  final AuthRepository _repo;
  AuthNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.signIn(email, password));
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _repo.register(
          email: email,
          password: password,
          name: name,
          phone: phone,
        ));
  }

  Future<void> signOut() async {
    await _repo.signOut();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<AppUser?>>((ref) =>
        AuthNotifier(ref.watch(authRepositoryProvider)));