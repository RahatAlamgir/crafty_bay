import 'package:crafty_bay/core/app_colors.dart';
import 'package:flutter/material.dart';

/// One square +/- button of a `QuantityStepper`. A null [onTap] disables it.
class QuantityStepButton extends StatelessWidget {
  const QuantityStepButton({
    super.key,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final IconData icon;

  /// Solid teal (+) vs. pale teal (−).
  final bool filled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.primaryLight,
          borderRadius: BorderRadius.circular(3),
        ),
        child: Icon(
          icon,
          size: 16,
          color: filled ? AppColors.textOnPrimary : AppColors.primary,
        ),
      ),
    );
  }
}
