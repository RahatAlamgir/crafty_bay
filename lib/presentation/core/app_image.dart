import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/presentation/core/app_image_placeholder.dart';
import 'package:flutter/material.dart';

/// An image that shows a placeholder while it loads and when it fails
/// (broken link, empty URL, no network), instead of an error box.
///
/// The placeholder fills whatever space the image would have taken and sizes
/// its icon from that space, so nothing is a fixed size.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.image,
    this.fit = BoxFit.cover,
    this.placeholderColor = AppColors.primary,
  });

  final ImageProvider image;
  final BoxFit fit;

  /// Color of the placeholder icon. Use a light color on dark backgrounds.
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: image,
      fit: fit,
      errorBuilder: (_, _, _) => AppImagePlaceholder(color: placeholderColor),
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;

        return AppImagePlaceholder(color: placeholderColor);
      },
    );
  }
}
