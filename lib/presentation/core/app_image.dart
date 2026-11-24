import 'package:crafty_bay/core/app_colors.dart';
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
      errorBuilder: (_, _, _) => _Placeholder(color: placeholderColor),
      frameBuilder: (_, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;

        return _Placeholder(color: placeholderColor);
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.hasBoundedWidth ? constraints.maxWidth : 80.0;
        final height = constraints.hasBoundedHeight
            ? constraints.maxHeight
            : width;

        return SizedBox(
          width: width,
          height: height,
          child: Center(
            child: Icon(
              Icons.image_outlined,
              // Icon is 70% of the smaller side, so it reads clearly even in
              // small cells and still scales up in big ones.
              size: (width < height ? width : height) * 0.7,
              color: color.withValues(alpha: 0.6),
            ),
          ),
        );
      },
    );
  }
}
