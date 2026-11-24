import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

/// Round picture of the user, or their initials when there is no picture.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({super.key, required this.profile, this.size = 96});

  final UserProfile profile;
  final double size;

  @override
  Widget build(BuildContext context) {
    final url = profile.avatarUrl;

    return Container(
      height: size,
      width: size,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: url == null
          ? _initials()
          : Image.network(
              url,
              height: size,
              width: size,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _initials(),
            ),
    );
  }

  Widget _initials() {
    return Text(
      profile.initials,
      style: TextStyle(
        fontSize: size * 0.34,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}
