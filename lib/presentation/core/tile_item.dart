import 'package:flutter/material.dart';

/// One tile of a [TileGridPage]: an icon, a name and what happens on tap.
class TileItem {
  final String iconUrl;
  final String name;
  final VoidCallback onTap;

  const TileItem({
    required this.iconUrl,
    required this.name,
    required this.onTap,
  });
}
