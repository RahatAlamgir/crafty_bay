import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/presentation/core/quantity_step_button.dart';
import 'package:flutter/material.dart';

/// Compact "− 01 +" control for cart lines and the product details page.
///
/// The parent owns the value: it passes [quantity] and updates it from
/// [onChanged]. The value is clamped between [min] and [max].
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  final int quantity;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        QuantityStepButton(
          icon: Icons.remove,
          filled: false,
          onTap: quantity > min ? () => onChanged(quantity - 1) : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            quantity.toString().padLeft(2, '0'),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        QuantityStepButton(
          icon: Icons.add,
          filled: true,
          onTap: quantity < max ? () => onChanged(quantity + 1) : null,
        ),
      ],
    );
  }
}
