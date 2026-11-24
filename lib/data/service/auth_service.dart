import 'dart:convert';

import '../../core/end_points.dart';
import '../../domain/entities/user_profile.dart';
import '../model/user_profile_model.dart';
import 'network/auth_headers.dart';
import 'network/network_caller.dart';
import 'network/network_response.dart';

/// Auth calls. None of the first four send a token (the user has none yet).
class AuthService {
  final _networkCaller = NetworkCaller();

  static const _json = {'accept': 'application/json'};

  /// Logs in and returns the JWT.
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.login),
      headers: _json,
      body: {'email': email, 'password': password},
    );
    _throwIfFailed(response);
    final token = _findToken(response.body);
    if (token == null) {
      throw Exception('Login succeeded but no token came back');
    }

    return token;
  }

  /// Registers an account; the server then emails an OTP.
  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.signup),
      headers: _json,
      body: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
    );
    _throwIfFailed(response);
  }

  /// Verifies the OTP. Returns a token only if the server includes one;
  /// otherwise null and the caller logs in with the password.
  Future<String?> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.verifyOtp),
      headers: _json,
      body: {'email': email, 'otp': otp},
    );
    _throwIfFailed(response);

    return _findToken(response.body);
  }

  Future<void> resendOtp(String email) async {
    final response = await _networkCaller.post(
      Uri.parse(EndPoints.resendOtp),
      headers: _json,
      body: {'email': email},
    );
    _throwIfFailed(response);
  }

  /// Loads the signed-in user's profile. Needs the login token.
  Future<UserProfile> getProfile() async {
    final response = await _networkCaller.get(
      Uri.parse(EndPoints.profile),
      headers: AuthHeaders.build(),
    );
    _throwIfFailed(response);
    final json = jsonDecode(response.body!);
    // The user may sit at `data`, or at `data.user`.
    final data = json is Map ? json['data'] : null;
    final user = data is Map ? (data['user'] ?? data) : null;
    if (user is! Map<String, dynamic>) {
      throw Exception('Profile came back in an unexpected format');
    }

    return UserProfileModel.fromJson(user);
  }

  /// Saves the extra profile details. Needs the login token.
  ///
  /// The server only accepts `phone` and `city`; any other key (such as a
  /// shipping address) is rejected with "Unexpected key".
  Future<void> updateProfile({
    required String phone,
    required String city,
  }) async {
    final response = await _networkCaller.patch(
      Uri.parse(EndPoints.profile),
      headers: AuthHeaders.build(),
      body: {'phone': phone, 'city': city},
    );
    _throwIfFailed(response);
  }

  void _throwIfFailed(NetworkResponse response) {
    if (response.isSuccess != true) throw Exception(response.errorMessage);
  }

  /// Looks for the JWT in the usual places of a `{data: ...}` response.
  String? _findToken(String? body) {
    if (body == null) return null;
    final json = jsonDecode(body);
    if (json is! Map) return null;
    for (final source in [json['data'], json]) {
      if (source is String && source.isNotEmpty) return source;
      if (source is Map) {
        for (final key in ['token', 'access_token', 'accessToken', 'jwt']) {
          final value = source[key];
          if (value is String && value.isNotEmpty) return value;
        }
      }
    }

    return null;
  }
}
