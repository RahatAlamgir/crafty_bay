import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/core/bottom_action_bar.dart';
import 'package:crafty_bay/presentation/core/bottom_bar_circle_button.dart';
import 'package:crafty_bay/presentation/feature/create_review/view/create_review_page.dart';
import 'package:crafty_bay/presentation/feature/reviews/widgets/review_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/review_provider.dart';

/// Reviews of one product, with a bottom bar showing the count and a button to
/// write a new review.
///
/// Reads the [ReviewProvider] given by the Product Details page, which has
/// already loaded the reviews. Pull down to refresh.
class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  void _onAddReview(BuildContext context) {
    // Passes the same provider on, so the new review shows up in this list.
    final provider = context.read<ReviewProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: const CreateReviewPage(),
        ),
      ),
    );
  }

  Widget _buildBody(ReviewProvider provider) {
    final reviews = provider.reviews;
    if (reviews.isEmpty && provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (reviews.isEmpty && provider.errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                provider.errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: provider.fetchReviews,
                child: const Text(AppStrings.retry),
              ),
            ],
          ),
        ),
      );
    }
    if (reviews.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            AppStrings.noReviewsYet,
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.fetchReviews,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: reviews.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (_, i) => ReviewCard(
          name: reviews[i].reviewerName,
          rating: reviews[i].rating,
          comment: reviews[i].comment,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ReviewProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: const Text(
          AppStrings.reviews,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _buildBody(provider),
      bottomNavigationBar: BottomActionBar(
        leading: Text(
          '${AppStrings.reviews} (${provider.reviews.length})',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        action: BottomBarCircleButton(onPressed: () => _onAddReview(context)),
      ),
    );
  }
}
