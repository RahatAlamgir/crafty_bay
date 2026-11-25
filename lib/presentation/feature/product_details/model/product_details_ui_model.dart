import 'package:crafty_bay/domain/entities/product_details.dart';
import 'package:flutter/material.dart';

/// What the Product Details page shows for one product: the API data reshaped
/// for the screen (price as a double, color names turned into swatch colors).
class ProductDetailsUiModel {
  const ProductDetailsUiModel({
    this.id = '',
    required this.title,
    required this.price,
    required this.rating,
    required this.description,
    required this.imagePaths,
    required this.colors,
    required this.colorNames,
    required this.sizes,
  });

  /// API product id; empty disables the cart and wish list buttons.
  final String id;
  final String title;
  final double price;
  final double rating;
  final String description;
  final List<String> imagePaths;
  final List<Color> colors;

  /// Display name of each entry in [colors], same order.
  final List<String> colorNames;
  final List<String> sizes;

  /// Builds the page model from API data. The product itself has no rating,
  /// so the caller passes the average of its reviews as [rating].
  factory ProductDetailsUiModel.fromEntity(
    ProductDetails p, {
    double rating = 0,
  }) {
    return ProductDetailsUiModel(
      id: p.id,
      title: p.title,
      price: p.currentPrice.toDouble(),
      rating: rating,
      description: p.description,
      imagePaths: p.photos,
      colors: [for (final c in p.colors) _colorFromName(c)],
      colorNames: p.colors,
      sizes: p.sizes,
    );
  }

  static const _namedColors = {
    'red': Colors.red,
    'blue': Colors.blue,
    'green': Colors.green,
    'purple': Colors.purple,
    'gold': Color(0xFFFFD700),
    'black': Colors.black,
    'white': Colors.white,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'pink': Colors.pink,
    'grey': Colors.grey,
    'gray': Colors.grey,
    'brown': Colors.brown,
    'silver': Color(0xFFC0C0C0),
  };

  static Color _colorFromName(String name) =>
      _namedColors[name.trim().toLowerCase()] ?? Colors.grey;
}
