import 'dart:async';

import 'package:crafty_bay/core/app_colors.dart';
import 'package:crafty_bay/core/app_strings.dart';
import 'package:crafty_bay/presentation/core/api_product_card.dart';
import 'package:crafty_bay/presentation/core/product_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/search_provider.dart';
import '../widgets/search_message.dart';

/// Type in the app bar, matching products appear below as you type.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  static const _debounce = Duration(milliseconds: 300);

  final _controller = TextEditingController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // After the first frame, so notifyListeners is not called mid-build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final search = context.read<SearchProvider>();
      search.reset();
      search.load();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String text) {
    // Waits for a short pause in typing instead of searching every letter.
    _timer?.cancel();
    _timer = Timer(_debounce, () {
      if (mounted) context.read<SearchProvider>().search(text);
    });
    setState(() {}); // shows or hides the clear button
  }

  void _onClear() {
    _timer?.cancel();
    _controller.clear();
    context.read<SearchProvider>().search('');
    setState(() {});
  }

  Widget _buildBody(SearchProvider search) {
    if (search.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (search.errorMessage.isNotEmpty) {
      return SearchMessage(
        text: search.errorMessage,
        actionLabel: AppStrings.retry,
        onAction: search.load,
      );
    }
    if (!search.hasQuery) {
      return const SearchMessage(
        icon: Icons.search,
        text: AppStrings.searchPrompt,
      );
    }
    if (search.results.isEmpty) {
      return SearchMessage(
        icon: Icons.search_off,
        text: '${AppStrings.noProductsFound} "${search.query}"',
      );
    }

    return ProductGrid(
      itemCount: search.results.length,
      itemBuilder: (_, i) => ApiProductCard(product: search.results[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onChanged: _onChanged,
          onSubmitted: (text) {
            _timer?.cancel();
            search.search(text);
          },
          decoration: InputDecoration(
            hintText: AppStrings.searchProducts,
            filled: true,
            fillColor: AppColors.surface,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            prefixIcon: const Icon(Icons.search, color: AppColors.icon),
            suffixIcon: _controller.text.isEmpty
                ? null
                : IconButton(
                    onPressed: _onClear,
                    icon: const Icon(Icons.close, color: AppColors.icon),
                  ),
            border: _border(BorderSide.none),
            enabledBorder: _border(BorderSide.none),
            focusedBorder: _border(
              const BorderSide(color: AppColors.primary),
            ),
          ),
        ),
      ),
      body: _buildBody(search),
    );
  }

  OutlineInputBorder _border(BorderSide side) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: side,
  );
}
