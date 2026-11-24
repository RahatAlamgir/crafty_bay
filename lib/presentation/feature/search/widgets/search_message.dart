import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';

/// Centered message for the search page: an optional icon, some text, and an
/// optional action button (e.g. Retry).
class SearchMessage extends StatelessWidget {
  const SearchMessage({
    super.key,
    required this.text,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String text;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 56, color: AppColors.iconInactive),
              const SizedBox(height: 12),
            ],
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
