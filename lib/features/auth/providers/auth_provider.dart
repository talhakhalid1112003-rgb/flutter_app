import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoring_app/core/providers/firebase_providers.dart';
import 'package:scoring_app/features/auth/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<User?>>(() {
      return AuthController();
    });

class AuthController extends Notifier<AsyncValue<User?>> {
  late final AuthService _service;
  late final FirebaseFirestore _firestore;

  @override
  AsyncValue<User?> build() {
    _service = ref.read(authServiceProvider);
    _firestore = ref.read(firestoreProvider);
    return AsyncValue.data(_service.currentUser);
  }

  Future<Map<String, dynamic>> _fetchOrCreateUserProfile(
    User user, {
    String? name,
    String? email,
  }) async {
    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (doc.exists) {
      return doc.data()!;
    }

    final profileData = {
      'userId': user.uid,
      'name': name ?? user.displayName ?? '',
      'email': email ?? user.email ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    };

    await docRef.set(profileData);
    return profileData;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.signInWithEmail(email, password);
      if (user == null) {
        throw Exception('Unable to sign in.');
      }

      await _fetchOrCreateUserProfile(user, email: email);
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    } catch (e, st) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        final error = Exception(
          'Firebase permission denied. Please check Firestore rules for the users collection.',
        );
        state = AsyncValue.error(error, st);
        rethrow;
      }
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUp(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.createUserWithEmail(email, password);
      if (user == null) {
        throw Exception('Unable to create account.');
      }

      await _fetchOrCreateUserProfile(user, name: name, email: email);
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    } catch (e, st) {
      if (e is FirebaseException && e.code == 'permission-denied') {
        final error = Exception(
          'Firebase permission denied while saving user profile. Please update Firestore rules for the users collection.',
        );
        state = AsyncValue.error(error, st);
        rethrow;
      }
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.signInWithGoogle();
      if (user == null) {
        throw Exception('Google sign-in cancelled or failed.');
      }

      // Fetch or create user profile with Google user data
      await _fetchOrCreateUserProfile(
        user,
        name: user.displayName,
        email: user.email,
      );
      state = AsyncValue.data(user);
    } on FirebaseAuthException catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    state = const AsyncValue.data(null);
  }

  Future<void> sendPasswordReset(String email) async {
    await _service.sendPasswordReset(email);
  }
}
