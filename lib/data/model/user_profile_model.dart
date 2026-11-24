import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    super.phone,
    super.city,
    super.avatarUrl,
    super.emailVerified,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      firstName: (json['first_name'] ?? '').toString(),
      lastName: (json['last_name'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      phone: _text(json['phone']),
      city: _text(json['city']),
      avatarUrl: _text(json['avatar_url']),
      emailVerified: json['email_verified'] == true,
    );
  }

  /// Empty or missing values become null so screens can show a placeholder.
  static String? _text(Object? value) {
    final text = value?.toString().trim() ?? '';

    return text.isEmpty ? null : text;
  }
}
