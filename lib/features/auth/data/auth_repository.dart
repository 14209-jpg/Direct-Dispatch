import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/firebase_providers.dart';
import '../domain/user_model.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final FirebaseMessaging _fcm;

  AuthRepository(this._auth, this._db, this._fcm);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Sign in ──────────────────────────────────────────────
  Future<AppUser> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    await _refreshFcmToken(cred.user!.uid);
    return (await _userDoc(cred.user!.uid))!;
  }

  // ── Register (customers self-register; admin created manually) ──
  Future<AppUser> register({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    final uid = cred.user!.uid;
    final token = await _fcm.getToken();

    final user = AppUser(
      id: uid,
      name: name,
      phone: phone,
      role: AppConstants.roleCustomer, // customers only via self-register
      email: email,
      fcmToken: token,
      createdAt: DateTime.now(),
    );

    await _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .set(user.toJson());
    return user;
  }

  Future<void> signOut() => _auth.signOut();

  Future<AppUser?> getCurrentUser() async {
    final u = _auth.currentUser;
    if (u == null) return null;
    return _userDoc(u.uid);
  }

  // ── Internal ─────────────────────────────────────────────
  Future<AppUser?> _userDoc(String uid) async {
    final doc = await _db
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .get();
    if (!doc.exists) return null;
    return AppUser.fromJson({...doc.data()!, 'id': doc.id});
  }

  Future<void> _refreshFcmToken(String uid) async {
    final token = await _fcm.getToken();
    if (token != null) {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({'fcmToken': token});
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      ref.watch(firebaseAuthProvider),
      ref.watch(firestoreProvider),
      ref.watch(firebaseMessagingProvider),
    ));