import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/profile_provider.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/profile_error_view.dart';
import '../widgets/profile_info_card.dart';
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
      return ProfileErrorView(
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
          ProfileInfoCard(profile: profile),
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
