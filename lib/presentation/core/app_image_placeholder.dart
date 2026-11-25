import 'package:flutter/material.dart';

/// Image icon shown by `AppImage` while a picture loads or when it fails.
/// Fills the space it is given and sizes the icon from it.
class AppImagePlaceholder extends StatelessWidget {
  const AppImagePlaceholder({super.key, required this.color});

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
