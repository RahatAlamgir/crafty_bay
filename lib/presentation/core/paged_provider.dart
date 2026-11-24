import 'package:crafty_bay/domain/entities/page_result.dart';
import 'package:flutter/foundation.dart';

/// Base for providers whose list comes from the server a page at a time:
/// the first page loads when the screen opens, the next as the user scrolls.
///
/// A subclass only says how to load one page ([loadPage]); loading, errors and
/// "is there more?" are handled here, the same way for every list.
abstract class PagedProvider<T> extends ChangeNotifier {
  final List<T> _items = [];
  List<T> get items => List.unmodifiable(_items);

  int _lastLoadedPage = 0;
  int _lastPage = 1;

  /// True while there are still pages on the server we have not loaded.
  bool get hasMore => _lastLoadedPage < _lastPage;

  /// First page loading (the screen shows a full-screen spinner).
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// A later page loading (a small spinner shows under the list).
  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  /// Error from the first page (full-screen message with Retry).
  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  /// Error from a later page (a Retry row shows under the list).
  String _moreErrorMessage = '';
  String get moreErrorMessage => _moreErrorMessage;

  /// Loads page [page] (1-based) from the server.
  @protected
  Future<PageResult<T>> loadPage(int page);

  /// (Re)loads from the first page, replacing what is shown.
  Future<void> fetchFirstPage() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();
    try {
      final page = await loadPage(1);
      _items
        ..clear()
        ..addAll(page.items);
      _lastLoadedPage = 1;
      _lastPage = page.lastPage;
      _moreErrorMessage = '';
    } catch (e) {
      _errorMessage = _clean(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the next page. Safe to call often: it does nothing while another
  /// page is loading or when there are no more pages.
  Future<void> fetchNextPage() async {
    if (_isLoading || _isLoadingMore || !hasMore) return;
    _isLoadingMore = true;
    _moreErrorMessage = '';
    notifyListeners();
    try {
      final page = await loadPage(_lastLoadedPage + 1);
      _items.addAll(page.items);
      _lastLoadedPage += 1;
      _lastPage = page.lastPage;
    } catch (e) {
      _moreErrorMessage = _clean(e);
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');
}
