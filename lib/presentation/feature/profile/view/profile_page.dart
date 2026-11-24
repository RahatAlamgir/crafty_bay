import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/profile_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_info_tile.dart';
import 'profile_edit_page.dart';

/// Shows the signed-in user's details, with a button to edit them.
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Runs after the first frame so notifyListeners is not called mid-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
    });
  }

  void _onEdit(UserProfile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProfileEditPage(profile: profile)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.profile)),
      body: _buildBody(provider, profile),
    );
  }

  Widget _buildBody(ProfileProvider provider, UserProfile? profile) {
    if (profile == null && provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (profile == null) {
      return _ErrorView(
        message: provider.errorMessage,
        onRetry: provider.fetchProfile,
      );
    }

    return RefreshIndicator(
      onRefresh: provider.fetchProfile,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Center(child: ProfileAvatar(profile: profile)),
          const SizedBox(height: 16),
          Text(
            profile.fullName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          _InfoCard(profile: profile),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _onEdit(profile),
            icon: const Icon(Icons.edit_outlined, size: 20),
            label: const Text(AppStrings.editProfile),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.profile});

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

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text(AppStrings.retry),
            ),
          ],
        ),
      ),
    );
  }
}
