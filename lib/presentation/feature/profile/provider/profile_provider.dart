import 'package:crafty_bay/data/service/auth_service.dart';
import 'package:crafty_bay/domain/entities/user_profile.dart';
import 'package:flutter/foundation.dart';

/// Owns the signed-in user's profile for the Profile and Edit Profile screens.
class ProfileProvider extends ChangeNotifier {
  final _service = AuthService();

  UserProfile? _profile;
  UserProfile? get profile => _profile;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Forgets the profile (logout), so the next user never sees it.
  void clear() {
    _profile = null;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> fetchProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      _profile = await _service.getProfile();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = _clean(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves phone and city, then reloads the profile so every screen agrees.
  /// Returns false (with [errorMessage] set) on failure.
  Future<bool> updateProfile({
    required String phone,
    required String city,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await _service.updateProfile(phone: phone, city: city);
      _profile = await _service.getProfile();
      _errorMessage = '';

      return true;
    } catch (e) {
      _errorMessage = _clean(e);

      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
