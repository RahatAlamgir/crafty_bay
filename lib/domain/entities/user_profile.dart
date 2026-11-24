/// The signed-in user's account details.
class UserProfile {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? city;
  final String? avatarUrl;
  final bool emailVerified;

  const UserProfile({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.city,
    this.avatarUrl,
    this.emailVerified = false,
  });

  String get fullName => '$firstName $lastName'.trim();

  /// Letters shown in the avatar when there is no picture.
  String get initials {
    final first = firstName.isEmpty ? '' : firstName[0];
    final last = lastName.isEmpty ? '' : lastName[0];

    return (first + last).toUpperCase();
  }
}
