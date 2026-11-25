import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/feature/reviews/provider/rating_provider.dart';
import 'package:crafty_bay/presentation/feature/reviews/provider/review_provider.dart';
import 'package:crafty_bay/presentation/feature/reviews/widgets/star_rating.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Write a review: pick a star rating and type a comment.
/// The reviewer's name comes from their login, so it is not asked for here.
class CreateReviewPage extends StatefulWidget {
  const CreateReviewPage({super.key});

  @override
  State<CreateReviewPage> createState() => _CreateReviewPageState();
}

class _CreateReviewPageState extends State<CreateReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _reviewController = TextEditingController();

  double _rating = 0;
  bool _showRatingError = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.fieldRequired;
    return null;
  }

  Future<void> _onSubmit() async {
    final formOk = _formKey.currentState!.validate();
    setState(() => _showRatingError = _rating == 0);
    if (!formOk || _rating == 0) return;

    final provider = context.read<ReviewProvider>();
    final ok = await provider.submit(
      rating: _rating,
      comment: _reviewController.text.trim(),
    );
    if (!mounted) return;
    // The new review changes this product's average on every product card.
    if (ok) context.read<RatingProvider>().fetchRatings();
    final message = ok ? AppStrings.reviewSubmitted : provider.errorMessage;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
    if (ok) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.watch<ReviewProvider>().isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.createReview,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  AppStrings.yourRating,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                StarRating(
                  rating: _rating,
                  size: 36,
                  onChanged: (value) => setState(() {
                    _rating = value;
                    _showRatingError = false;
                  }),
                ),
                if (_showRatingError) ...[
                  const SizedBox(height: 6),
                  const Text(
                    AppStrings.ratingRequired,
                    style: TextStyle(fontSize: 12, color: AppColors.error),
                  ),
                ],
                const SizedBox(height: 20),
                TextFormField(
                  controller: _reviewController,
                  maxLines: 8,
                  textInputAction: TextInputAction.newline,
                  validator: _validateRequired,
                  decoration: const InputDecoration(
                    hintText: AppStrings.writeReview,
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSubmitting ? null : _onSubmit,
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(AppStrings.submit),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
