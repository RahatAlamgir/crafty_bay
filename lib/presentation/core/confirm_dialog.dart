import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:flutter/material.dart';

/// Asks the user to confirm an action. Returns true only when they tap the
/// confirm button; cancelling or tapping outside returns false.
///
/// Set [destructive] for removals so the confirm button is red.
Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      content: Text(
        message,
        style: const TextStyle(color: AppColors.textSecondary),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text(
            AppStrings.cancel,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: Text(
            confirmLabel,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: destructive ? AppColors.error : AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );

  return confirmed ?? false;
}
