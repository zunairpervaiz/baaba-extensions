extension ListX<T> on Iterable<T>? {
  /// Returns a non-null [List], falling back to an empty list when null.
  List<T> validate() => this == null ? [] : this!.toList();

  /// Calls [action] for each element together with its zero-based index.
  void forEachIndexed(void Function(int index, T element) action) {
    if (this == null) return;
    var index = 0;
    for (final element in this!) {
      action(index++, element);
    }
  }

  /// Returns the sum of integer values produced by [selector].
  ///
  /// Example: `[1, 3, 7].sumBy((n) => n)` → `11`
  int sumBy(int Function(T) selector) =>
      validate().map(selector).fold(0, (a, b) => a + b);

  /// Returns the sum of numeric values produced by [selector] as a [double].
  ///
  /// Example: `['hi', 'world'].sumByDouble((s) => s.length)` → `7.0`
  double sumByDouble(num Function(T) selector) =>
      validate().map(selector).fold(0.0, (a, b) => a + b);

  /// Returns the average of values produced by [selector], or null if empty.
  ///
  /// Example: `[1, 2, 3].averageBy((n) => n)` → `2.0`
  double? averageBy(num Function(T) selector) {
    final list = validate();
    if (list.isEmpty) return null;
    return sumByDouble(selector) / list.length;
  }

  /// Groups elements into a map keyed by the result of [keySelector].
  ///
  /// Example: `users.groupBy((u) => u.role)` → `Map<Role, List<User>>`
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in validate()) {
      map.putIfAbsent(keySelector(element), () => []).add(element);
    }
    return map;
  }

  /// Returns the first element matching [predicate], or null if none found.
  T? firstWhereOrNull(bool Function(T) predicate) {
    if (this == null) return null;
    for (final element in this!) {
      if (predicate(element)) return element;
    }
    return null;
  }

  /// Returns a new list with duplicate elements removed, preserving order.
  List<T> distinct() {
    final seen = <T>{};
    return validate().where(seen.add).toList();
  }

  /// Returns a sorted copy using [keySelector] for comparison.
  ///
  /// Example: `users.sortedBy((u) => u.name)`
  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    list.sort((a, b) => keySelector(a).compareTo(keySelector(b)));
    return list;
  }

  /// Maps each element together with its index.
  ///
  /// Example: `items.mapIndexed((i, e) => '$i: $e')`
  List<R> mapIndexed<R>(R Function(int index, T element) transform) {
    final result = <R>[];
    var i = 0;
    for (final e in validate()) {
      result.add(transform(i++, e));
    }
    return result;
  }

  /// Returns the number of elements that satisfy [predicate].
  int countWhere(bool Function(T) predicate) =>
      validate().where(predicate).length;

  /// Returns the element with the highest value produced by [keySelector],
  /// or null if the iterable is empty.
  T? maxBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    if (list.isEmpty) return null;
    return list.reduce(
      (a, b) => keySelector(a).compareTo(keySelector(b)) >= 0 ? a : b,
    );
  }

  /// Returns the element with the lowest value produced by [keySelector],
  /// or null if the iterable is empty.
  T? minBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    if (list.isEmpty) return null;
    return list.reduce(
      (a, b) => keySelector(a).compareTo(keySelector(b)) <= 0 ? a : b,
    );
  }

  /// Returns true when no element satisfies [predicate].
  bool none(bool Function(T) predicate) => !validate().any(predicate);
}

extension ListSplit<T> on List<T> {
  /// Splits the list at [index] and returns a record of the two halves.
  ///
  /// Example: `[1,2,3,4,5].splitAt(2)` → `(before: [1,2], after: [3,4,5])`
  ({List<T> before, List<T> after}) splitAt(int index) {
    final splitPoint = index.clamp(0, length);
    return (before: sublist(0, splitPoint), after: sublist(splitPoint));
  }

  /// Splits the list into chunks of [size].
  ///
  /// Example: `[1,2,3,4,5].chunked(2)` → `[[1,2],[3,4],[5]]`
  List<List<T>> chunked(int size) {
    if (size <= 0) return [this];
    return List.generate((length / size).ceil(), (i) {
      final start = i * size;
      return sublist(start, (start + size).clamp(0, length));
    });
  }

  /// Partitions the list into elements that satisfy [predicate] and those that don't.
  ///
  /// Example: `[1,2,3,4].partition((n) => n.isEven)` → `(matching: [2,4], remaining: [1,3])`
  ({List<T> matching, List<T> remaining}) partition(bool Function(T) predicate) {
    final matching = <T>[];
    final remaining = <T>[];
    for (final element in this) {
      (predicate(element) ? matching : remaining).add(element);
    }
    return (matching: matching, remaining: remaining);
  }
}

extension ListSwapExtension<E> on List<E> {
  /// Swaps the elements at [index1] and [index2] in-place.
  void swap(int index1, int index2) {
    if (index1 < 0 || index1 >= length || index2 < 0 || index2 >= length) {
      throw RangeError('Index out of bounds');
    }
    final temp = this[index1];
    this[index1] = this[index2];
    this[index2] = temp;
  }
}

extension IterableIterableX<T> on Iterable<Iterable<T>> {
  /// Flattens nested iterables into a single [List].
  ///
  /// Example: `[[1,2],[3,4]].flatten()` → `[1,2,3,4]`
  List<T> flatten() => expand((e) => e).toList();
}
