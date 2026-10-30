import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart' hide Category;
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  StreamSubscription<User?>? _sub;

  AppUser? _user;
  bool _initializing = true; // menunggu cek sesi login tersimpan
  bool _loading = false; // sedang proses login/daftar
  bool _busy = false; // cegah listener bentrok saat login/daftar
  String? _error;

  AuthViewModel(this._repo) {
    _sub = _repo.authStateChanges.listen(_onAuthChanged);
  }

  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get initializing => _initializing;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> _onAuthChanged(User? firebaseUser) async {
    if (_busy) return;
    if (firebaseUser == null) {
      _user = null;
    } else {
      try {
        _user = await _repo.loadProfile(firebaseUser);
      } catch (_) {
        _user = null;
        _error = 'Gagal memuat profil. Periksa koneksi dan aturan Firestore.';
      }
    }
    _initializing = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) =>
      _run(() => _repo.login(email, password));

  Future<bool> register(String name, String email, String password) =>
      _run(() => _repo.register(name, email, password));

  Future<bool> _run(Future<AppUser> Function() action) async {
    _busy = true;
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _user = await action();
      _initializing = false;
      return true;
    } on AuthFailure catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      return false;
    } finally {
      _busy = false;
      _loading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repo.logout();
    _user = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
