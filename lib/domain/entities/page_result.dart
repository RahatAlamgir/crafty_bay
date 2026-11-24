/// One page of a server list, plus how many pages exist in total.
class PageResult<T> {
  final List<T> items;
  final int lastPage;

  const PageResult({required this.items, required this.lastPage});
}
