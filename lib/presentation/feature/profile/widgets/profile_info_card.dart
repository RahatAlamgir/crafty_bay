import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';

import 'profile_info_tile.dart';

/// Bordered card listing email (with its verified state), mobile and city.
class ProfileInfoCard extends StatelessWidget {
  const ProfileInfoCard({super.key, required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ProfileInfoTile(
            icon: Icons.email_outlined,
            label: AppStrings.email,
            value: profile.email,
            trailing: Text(
              profile.emailVerified
                  ? AppStrings.verified
                  : AppStrings.notVerified,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: profile.emailVerified
                    ? AppColors.success
                    : AppColors.error,
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          ProfileInfoTile(
            icon: Icons.phone_outlined,
            label: AppStrings.mobile,
            value: profile.phone,
          ),
          const Divider(height: 1, color: AppColors.divider),
          ProfileInfoTile(
            icon: Icons.location_city_outlined,
            label: AppStrings.city,
            value: profile.city,
          ),
        ],
      ),
    );
  }
}
