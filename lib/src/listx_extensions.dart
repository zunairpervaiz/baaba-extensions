extension ListX<T> on Iterable<T>? {
  List<T> validate() {
    if (this == null) return [];
    return this!.toList();
  }

  /// Executes the provided [action] for each element in the list, along with its index.
  void forEachIndexed(void Function(int index, T element) action) {
    if (this == null) return;
    int index = 0;
    for (var element in this!) {
      action(index, element);
      index++;
    }
  }

  /// Example:
  /// ```dart
  /// [1, 3, 7].sumBy((n) => n);                 // 11
  /// ['hello', 'world'].sumBy((s) => s.length); // 10
  /// ```
  int sumBy(int Function(T) selector) {
    return validate().map(selector).fold(0, (prev, curr) => prev + curr);
  }

  /// Example:
  /// ```dart
  /// [1.5, 2.5].sumByDouble((d) => 0.5 * d); // 2.0
  /// ```
  double sumByDouble(num Function(T) selector) {
    return validate().map(selector).fold(0.0, (prev, curr) => prev + curr);
  }

  /// Example:
  /// ```dart
  /// [1, 2, 3].averageBy((n) => n);               // 2.0
  /// ['cat', 'horse'].averageBy((s) => s.length); // 4.0
  /// ```
  double? averageBy(num Function(T) selector) {
    if (validate().isEmpty) {
      return null;
    }

    return sumByDouble(selector) / this!.length;
  }

  /// Groups elements by a key and returns a Map.
  /// Example: users.groupBy((u) => u.role);
  Map<K, List<T>> groupBy<K>(K Function(T) keySelector) {
    final map = <K, List<T>>{};
    for (final element in validate()) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Finds the first element matching the [test], or returns null if not found.
  /// A safer version of .firstWhere()
  /// Example: [1, 2, 3].firstWhereOrNull((n) => n > 2); // returns 3
  T? firstWhereOrNull(bool Function(T) predicate) {
    if (this == null) return null;
    for (var element in this!) {
      if (predicate(element)) {
        return element;
      }
    }
    return null;
  }
}

extension ListSplit<T> on List<T> {
  /// Splits the list into two parts at the specified [index]. The [before] part contains elements before the index, and the [after] part contains elements from the index onward.
  /// If the index is out of bounds, it will be clamped to the valid range of the list.
  /// Example: [1, 2, 3, 4, 5].splitAt(2) => (before: [1, 2], after: [3, 4, 5])
  ({List<T> before, List<T> after}) splitAt(int index) {
    final splitPoint = index.clamp(0, length);
    return (before: sublist(0, splitPoint), after: sublist(splitPoint));
  }

  /// Splits the list into chunks of a specific [size].
  /// Example: [1, 2, 3, 4, 5].chunks(2) => [[1, 2], [3, 4], [5]]
  List<List<T>> chunked(int size) {
    if (size <= 0) return [this];

    return List.generate((length / size).ceil(), (i) {
      final start = i * size;
      final end = (start + size < length) ? start + size : length;
      return sublist(start, end);
    });
  }

  /// Splits the list into two: those that satisfy [predicate] and those that don't.
  /// Returns a Record (matching, remaining).
  /// Example: [1, 2, 3, 4].partition((n) => n % 2 == 0) => (matching: [2, 4], remaining: [1, 3])
  ({List<T> matching, List<T> remaining}) partition(bool Function(T) predicate) {
    final matching = <T>[];
    final remaining = <T>[];

    for (final element in this) {
      if (predicate(element)) {
        matching.add(element);
      } else {
        remaining.add(element);
      }
    }
    return (matching: matching, remaining: remaining);
  }
}

extension ListSwapExtension<E> on List<E> {
  void swap(int index1, int index2) {
    if (index1 < 0 || index1 >= length || index2 < 0 || index2 >= length) {
      throw RangeError('Index out of bounds');
    }
    final temp = this[index1];
    this[index1] = this[index2];
    this[index2] = temp;
  }
}
