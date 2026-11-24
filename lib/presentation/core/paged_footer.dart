import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/core/paged_provider.dart';
import 'package:flutter/material.dart';

/// What to show under a paged list: a spinner while the next page loads, a
/// Retry row if it failed, or nothing (null) otherwise.
Widget? buildPagedFooter(PagedProvider<dynamic> provider) {
  if (provider.isLoadingMore) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
  if (provider.moreErrorMessage.isNotEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            provider.moreErrorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          TextButton(
            onPressed: provider.fetchNextPage,
            child: const Text(AppStrings.retry),
          ),
        ],
      ),
    );
  }

  return null;
}
