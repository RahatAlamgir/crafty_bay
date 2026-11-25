import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/domain/entities/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../provider/profile_provider.dart';
import '../widgets/profile_avatar.dart';

/// Edits the details the server lets us change: mobile and city.
/// Name and email are shown but cannot be edited.
class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final _mobileController = TextEditingController(
    text: widget.profile.phone ?? '',
  );
  late final _cityController = TextEditingController(
    text: widget.profile.city ?? '',
  );

  @override
  void dispose() {
    _mobileController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    return (value == null || value.trim().isEmpty)
        ? AppStrings.fieldRequired
        : null;
  }

  String? _validateMobile(String? value) {
    final required = _validateRequired(value);
    if (required != null) return required;
    if (!RegExp(r'^\+?\d{7,15}$').hasMatch(value!.trim())) {
      return AppStrings.phoneInvalid;
    }

    return null;
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;
    final provider = context.read<ProfileProvider>();
    final ok = await provider.updateProfile(
      phone: _mobileController.text.trim(),
      city: _cityController.text.trim(),
    );
    if (!mounted) return;
    final message = ok ? AppStrings.profileUpdated : provider.errorMessage;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileProvider>().isSaving;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text(AppStrings.editProfile)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ProfileAvatar(profile: widget.profile),
                const SizedBox(height: 12),
                Text(
                  widget.profile.fullName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.profile.email,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  AppStrings.nameCannotChange,
                  style: TextStyle(fontSize: 12, color: AppColors.inputHint),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                  ],
                  validator: _validateMobile,
                  decoration: const InputDecoration(
                    hintText: AppStrings.mobile,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _cityController,
                  textInputAction: TextInputAction.done,
                  validator: _validateRequired,
                  onFieldSubmitted: (_) => _onSave(),
                  decoration: const InputDecoration(hintText: AppStrings.city),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: isSaving ? null : _onSave,
                  child: isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.saveChanges),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
