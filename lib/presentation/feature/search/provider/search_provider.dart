import 'package:crafty_bay/data/service/product_service.dart';
import 'package:crafty_bay/domain/entities/product.dart';
import 'package:flutter/foundation.dart';

/// Searches products by title.
///
/// The server cannot search, so the whole catalogue is loaded once (on the
/// first search) and every later search filters that list instantly.
class SearchProvider extends ChangeNotifier {
  final _service = ProductService();

  List<Product> _catalogue = [];
  bool _isLoaded = false;

  String _query = '';
  String get query => _query;

  List<Product> _results = [];
  List<Product> get results => _results;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// True while there is something typed to search for.
  bool get hasQuery => _query.isNotEmpty;

  /// Loads the catalogue if it is not loaded yet, then re-applies the query.
  Future<void> load() async {
    if (_isLoaded || _isLoading) return;
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      _catalogue = await _service.getAllProducts();
      _isLoaded = true;
      _results = _filter(_query);
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String text) {
    _query = text.trim();
    _results = _filter(_query);
    notifyListeners();
  }

  /// Clears the text and results; the loaded catalogue is kept.
  void reset() {
    _query = '';
    _results = [];
    notifyListeners();
  }

  /// Keeps products whose title contains every word typed, ignoring case.
  List<Product> _filter(String text) {
    final words = text.toLowerCase().split(RegExp(r'\s+'))
      ..removeWhere((w) => w.isEmpty);
    if (words.isEmpty) return [];

    return _catalogue.where((product) {
      final title = product.title.toLowerCase();

      return words.every(title.contains);
    }).toList();
  }
}
