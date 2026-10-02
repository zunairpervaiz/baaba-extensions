import 'dart:math';

extension ListX<T> on Iterable<T>? {
  /// Returns a non-null [List], falling back to an empty list when null.
  List<T> validate() => this == null ? [] : this!.toList();

  /// Returns `true` when this iterable is null or holds no elements.
  ///
  /// Example: `List<int>? items; items.isEmptyOrNull` → `true`
  bool get isEmptyOrNull => this == null || this!.isEmpty;

  /// Returns `true` when this iterable is non-null and holds at least one element.
  bool get isNotEmptyOrNull => this != null && this!.isNotEmpty;

  /// Returns the number of elements, or `0` when null.
  int get lengthOrZero => this == null ? 0 : this!.length;

  /// Returns the first element, or null when the iterable is null or empty.
  ///
  /// Unlike `Iterable.firstOrNull` this also accepts a null receiver, so no
  /// `?.` is needed.
  T? get firstOrNull {
    final iterable = this;
    if (iterable == null) return null;
    final iterator = iterable.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }

  /// Returns the last element, or null when the iterable is null or empty.
  T? get lastOrNull {
    final iterable = this;
    if (iterable == null) return null;
    T? last;
    var found = false;
    for (final element in iterable) {
      last = element;
      found = true;
    }
    return found ? last : null;
  }

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
  int sumBy(int Function(T) selector) => validate().map(selector).fold(0, (a, b) => a + b);

  /// Returns the sum of numeric values produced by [selector] as a [double].
  ///
  /// Example: `['hi', 'world'].sumByDouble((s) => s.length)` → `7.0`
  double sumByDouble(num Function(T) selector) => validate().map(selector).fold(0.0, (a, b) => a + b);

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

  /// Counts how many elements fall into each group produced by [keySelector].
  ///
  /// Cheaper than `groupBy(...).map((k, v) => MapEntry(k, v.length))` because
  /// the elements themselves are never collected.
  ///
  /// Example: `orders.groupCountBy((o) => o.status)` → `{pending: 4, paid: 12}`
  Map<K, int> groupCountBy<K>(K Function(T) keySelector) {
    final map = <K, int>{};
    for (final element in validate()) {
      final key = keySelector(element);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  /// Indexes the elements by the key produced by [keySelector].
  ///
  /// When two elements share a key the later one wins. Use [groupBy] instead
  /// when duplicates must be kept.
  ///
  /// Example: `users.associateBy((u) => u.id)` → `Map<String, User>`
  Map<K, T> associateBy<K>(K Function(T) keySelector) {
    final map = <K, T>{};
    for (final element in validate()) {
      map[keySelector(element)] = element;
    }
    return map;
  }

  /// Builds a map from the elements, deriving both key and value.
  ///
  /// Example: `users.associateWith((u) => u.id, (u) => u.name)`
  Map<K, V> associateWith<K, V>(K Function(T) keySelector, V Function(T) valueSelector) {
    final map = <K, V>{};
    for (final element in validate()) {
      map[keySelector(element)] = valueSelector(element);
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

  /// Returns the last element matching [predicate], or null if none found.
  T? lastWhereOrNull(bool Function(T) predicate) {
    if (this == null) return null;
    T? match;
    for (final element in this!) {
      if (predicate(element)) match = element;
    }
    return match;
  }

  /// Returns the only element matching [predicate], or null when there is no
  /// match or more than one.
  ///
  /// Unlike [Iterable.singleWhere] this never throws.
  T? singleWhereOrNull(bool Function(T) predicate) {
    if (this == null) return null;
    T? match;
    var found = false;
    for (final element in this!) {
      if (!predicate(element)) continue;
      if (found) return null;
      match = element;
      found = true;
    }
    return match;
  }

  /// Returns the index of the first element matching [predicate], or null.
  ///
  /// Returns null rather than `-1`, so the result composes with `??`.
  int? indexWhereOrNull(bool Function(T) predicate) {
    if (this == null) return null;
    var index = 0;
    for (final element in this!) {
      if (predicate(element)) return index;
      index++;
    }
    return null;
  }

  /// Returns a new list with duplicate elements removed, preserving order.
  List<T> distinct() {
    final seen = <T>{};
    return validate().where(seen.add).toList();
  }

  /// Returns a new list keeping only the first element for each key produced
  /// by [keySelector], preserving order.
  ///
  /// [distinct] compares whole elements, which is useless for model objects
  /// that lack value equality; this compares an identifier instead.
  ///
  /// Example: `users.distinctBy((u) => u.id)`
  List<T> distinctBy<K>(K Function(T) keySelector) {
    final seen = <K>{};
    return validate().where((element) => seen.add(keySelector(element))).toList();
  }

  /// Returns a sorted copy using [keySelector] for comparison.
  ///
  /// Example: `users.sortedBy((u) => u.name)`
  List<T> sortedBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    list.sort((a, b) => keySelector(a).compareTo(keySelector(b)));
    return list;
  }

  /// Returns a sorted copy in descending order using [keySelector].
  ///
  /// Example: `posts.sortedByDescending((p) => p.createdAt)`
  List<T> sortedByDescending<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    list.sort((a, b) => keySelector(b).compareTo(keySelector(a)));
    return list;
  }

  /// Returns a sorted copy using an explicit [comparator].
  List<T> sortedWith(Comparator<T> comparator) {
    final list = validate();
    list.sort(comparator);
    return list;
  }

  /// Returns a sorted copy, comparing by each selector in turn and moving to
  /// the next only when the previous one ties.
  ///
  /// Example: `users.sortedByMany([(u) => u.lastName, (u) => u.firstName])`
  List<T> sortedByMany(List<Comparable<dynamic> Function(T)> selectors) {
    final list = validate();
    list.sort((a, b) {
      for (final selector in selectors) {
        final result = selector(a).compareTo(selector(b));
        if (result != 0) return result;
      }
      return 0;
    });
    return list;
  }

  /// Returns `true` when the elements are already in ascending order by
  /// [keySelector].
  bool isSortedBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    for (var i = 1; i < list.length; i++) {
      if (keySelector(list[i - 1]).compareTo(keySelector(list[i])) > 0) return false;
    }
    return true;
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

  /// Maps each element and drops the results that come back null, in a single
  /// pass.
  ///
  /// Example: `rows.mapNotNull((r) => int.tryParse(r.id))`
  List<R> mapNotNull<R>(R? Function(T element) transform) {
    final result = <R>[];
    for (final element in validate()) {
      final mapped = transform(element);
      if (mapped != null) result.add(mapped);
    }
    return result;
  }

  /// Keeps only the elements whose [selector] value is non-null.
  ///
  /// Example: `users.whereNotNullBy((u) => u.email)`
  List<T> whereNotNullBy(Object? Function(T element) selector) => validate().where((e) => selector(e) != null).toList();

  /// Returns the number of elements that satisfy [predicate].
  int countWhere(bool Function(T) predicate) => validate().where(predicate).length;

  /// Returns the element with the highest value produced by [keySelector],
  /// or null if the iterable is empty.
  T? maxBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    if (list.isEmpty) return null;
    return list.reduce((a, b) => keySelector(a).compareTo(keySelector(b)) >= 0 ? a : b);
  }

  /// Returns the element with the lowest value produced by [keySelector],
  /// or null if the iterable is empty.
  T? minBy<K extends Comparable<K>>(K Function(T) keySelector) {
    final list = validate();
    if (list.isEmpty) return null;
    return list.reduce((a, b) => keySelector(a).compareTo(keySelector(b)) <= 0 ? a : b);
  }

  /// Returns true when no element satisfies [predicate].
  bool none(bool Function(T) predicate) => !validate().any(predicate);

  /// Returns `true` when at least one element of [other] is present.
  ///
  /// Example: `userRoles.containsAny([Role.admin, Role.owner])`
  bool containsAny(Iterable<T> other) {
    final set = validate().toSet();
    return other.any(set.contains);
  }

  /// Returns `true` when every element of [other] is present.
  bool containsAll(Iterable<T> other) {
    final set = validate().toSet();
    return other.every(set.contains);
  }

  /// Returns the elements of this iterable that are not in [other],
  /// preserving order.
  List<T> except(Iterable<T> other) {
    final set = other.toSet();
    return validate().where((e) => !set.contains(e)).toList();
  }

  /// Returns the elements present in both iterables, preserving this
  /// iterable's order and dropping duplicates.
  List<T> intersect(Iterable<T> other) {
    final set = other.toSet();
    final seen = <T>{};
    return validate().where((e) => set.contains(e) && seen.add(e)).toList();
  }

  /// Returns one client-side page of this iterable.
  ///
  /// [page] is counted from [firstPage], matching `PaginatorX.firstPage`, so
  /// the default numbering starts at `1`. An out-of-range page yields an
  /// empty list rather than throwing.
  ///
  /// Example: `products.pageAt(2, size: 20)` → items 21-40
  List<T> pageAt(int page, {int size = 20, int firstPage = 1}) {
    if (size <= 0) return [];
    final list = validate();
    final start = (page - firstPage) * size;
    if (start < 0 || start >= list.length) return [];
    return list.sublist(start, (start + size).clamp(0, list.length));
  }

  /// Returns a shuffled copy, leaving the original untouched.
  ///
  /// Pass a seeded [random] to make the order reproducible in tests.
  List<T> shuffled([Random? random]) => validate()..shuffle(random);

  /// Returns a random element, or null when the iterable is null or empty.
  T? randomOrNull([Random? random]) {
    final list = validate();
    if (list.isEmpty) return null;
    return list[(random ?? Random()).nextInt(list.length)];
  }

  /// Joins the elements into a string using [selector] for each one.
  ///
  /// Example: `users.joinToString((u) => u.name, separator: ', ')`
  String joinToString(String Function(T element) selector, {String separator = ', ', String prefix = '', String suffix = ''}) =>
      '$prefix${validate().map(selector).join(separator)}$suffix';
}

extension IterableNullableX<T extends Object> on Iterable<T?>? {
  /// Returns a list with every null element removed.
  ///
  /// Example: `[1, null, 3].whereNotNull()` → `[1, 3]`
  List<T> whereNotNull() {
    final iterable = this;
    if (iterable == null) return [];
    final result = <T>[];
    for (final element in iterable) {
      if (element != null) result.add(element);
    }
    return result;
  }

  /// Returns the first non-null element, or null when there is none.
  T? get firstNotNull {
    final iterable = this;
    if (iterable == null) return null;
    for (final element in iterable) {
      if (element != null) return element;
    }
    return null;
  }
}

extension IterableAsyncX<T> on Iterable<T>? {
  /// Awaits [transform] for each element **one at a time**, in order.
  ///
  /// Use this when the work must not overlap — sequential writes, or an API
  /// that rate-limits. Use [mapParallel] when the calls are independent.
  Future<List<R>> mapAsync<R>(Future<R> Function(T element) transform) async {
    final result = <R>[];
    for (final element in validate()) {
      result.add(await transform(element));
    }
    return result;
  }

  /// Runs [transform] for every element concurrently and returns the results
  /// in the original order.
  ///
  /// [concurrency] caps how many run at once. Leave it null to start them all
  /// together — but note that firing an unbounded number of requests at a
  /// server is a common way to cause timeouts, so prefer a cap for network
  /// work.
  ///
  /// Example: `ids.mapParallel((id) => api.fetch(id), concurrency: 4)`
  ///
  /// Throws an [ArgumentError] when [concurrency] is zero or negative.
  Future<List<R>> mapParallel<R>(Future<R> Function(T element) transform, {int? concurrency}) async {
    if (concurrency != null && concurrency <= 0) {
      throw ArgumentError.value(concurrency, 'concurrency', 'IterableAsyncX.mapParallel: must be greater than zero');
    }
    final list = validate();
    if (list.isEmpty) return <R>[];
    if (concurrency == null || concurrency >= list.length) {
      return Future.wait(list.map(transform));
    }

    final results = List<R?>.filled(list.length, null);
    var next = 0;
    Future<void> worker() async {
      while (true) {
        final index = next++;
        if (index >= list.length) return;
        results[index] = await transform(list[index]);
      }
    }

    await Future.wait(List.generate(concurrency, (_) => worker()));
    return results.map((e) => e as R).toList();
  }

  /// Awaits [action] for each element one at a time, in order.
  Future<void> forEachAsync(Future<void> Function(T element) action) async {
    for (final element in validate()) {
      await action(element);
    }
  }

  /// Returns the first element for which [predicate] resolves to `true`,
  /// or null when none does.
  ///
  /// Stops at the first match, so later elements are never tested.
  Future<T?> firstWhereAsync(Future<bool> Function(T element) predicate) async {
    for (final element in validate()) {
      if (await predicate(element)) return element;
    }
    return null;
  }
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
  /// When [size] is zero or negative, returns a single chunk holding a copy of
  /// the whole list, or no chunks when the list is empty. Every chunk is a new
  /// list; the receiver is never returned.
  ///
  /// Example: `[1,2,3,4,5].chunked(2)` → `[[1,2],[3,4],[5]]`
  List<List<T>> chunked(int size) {
    if (size <= 0) return isEmpty ? <List<T>>[] : [List<T>.of(this)];
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

extension ListAccessX<T> on List<T> {
  /// Returns the element at [index], or null when the index is out of range.
  ///
  /// Example: `['a','b'].getOrNull(5)` → `null`
  T? getOrNull(int index) => index < 0 || index >= length ? null : this[index];

  /// Returns the element at [index], or [fallback] when out of range.
  T getOrElse(int index, T fallback) => index < 0 || index >= length ? fallback : this[index];

  /// Returns a sublist with both bounds clamped into range, so an out-of-range
  /// request yields fewer elements instead of throwing.
  ///
  /// Example: `[1,2,3].safeSublist(1, 99)` → `[2, 3]`
  List<T> safeSublist(int start, [int? end]) {
    if (isEmpty) return [];
    final from = start.clamp(0, length);
    final to = (end ?? length).clamp(from, length);
    return sublist(from, to);
  }
}

extension ListMutationX<T> on List<T> {
  /// Removes [item] when present, adds it when absent. Mutates in place.
  ///
  /// This is the whole of a multi-select filter's logic.
  ///
  /// Example: `selectedIds.toggle(id)`
  void toggle(T item) {
    if (!remove(item)) add(item);
  }

  /// Moves the element at [from] to [to], shifting the rest. Mutates in place.
  ///
  /// [to] is the element's index after the move, which is what
  /// `ReorderableListView.onReorderItem` hands you, so its arguments can be
  /// passed straight through. (The deprecated `onReorder` passes an index
  /// computed before removal, which is off by one when moving down.) Returns
  /// `false` and changes nothing when either index is out of range.
  ///
  /// Example: `['a','b','c'].moveItem(0, 2)` → `['b','c','a']`
  bool moveItem(int from, int to) {
    if (from < 0 || from >= length || to < 0 || to >= length || from == to) return false;
    insert(to, removeAt(from));
    return true;
  }

  /// Adds [item] only when [condition] is true. Mutates in place.
  ///
  /// Example: `actions.addIf(user.isAdmin, deleteAction)`
  void addIf(bool condition, T item) {
    if (condition) add(item);
  }

  /// Adds every element of [items] only when [condition] is true.
  void addAllIf(bool condition, Iterable<T> items) {
    if (condition) addAll(items);
  }

  /// Removes every element matching [predicate] and returns how many went.
  int removeWhereCounted(bool Function(T) predicate) {
    final before = length;
    removeWhere(predicate);
    return before - length;
  }
}

extension ListTransformX<T> on List<T> {
  /// Returns a copy with every element matching [test] swapped for
  /// [replacement]. The original list is untouched.
  ///
  /// Example: `todos.replaceWhere((t) => t.id == id, updatedTodo)`
  List<T> replaceWhere(bool Function(T element) test, T replacement) => [
    for (final element in this) test(element) ? replacement : element,
  ];

  /// Returns a copy with [item] replacing the first element that shares its
  /// key, or with [item] appended when no element matches.
  ///
  /// The optimistic create-or-update in one call. The original is untouched.
  ///
  /// Example: `state.orders.upsert(order, by: (o) => o.id)`
  List<T> upsert(T item, {required Object? Function(T element) by}) {
    final key = by(item);
    final result = List<T>.from(this);
    final index = result.indexWhere((element) => by(element) == key);
    if (index == -1) {
      result.add(item);
    } else {
      result[index] = item;
    }
    return result;
  }

  /// Returns a copy rotated left by [n] positions, wrapping around. A negative
  /// [n] rotates right. The original is untouched.
  ///
  /// Example: `[1,2,3,4].rotate(1)` → `[2,3,4,1]`
  List<T> rotate(int n) {
    if (isEmpty) return [];
    final shift = n % length;
    if (shift == 0) return List<T>.from(this);
    final offset = shift < 0 ? shift + length : shift;
    return [...sublist(offset), ...sublist(0, offset)];
  }

  /// Returns what would have to be added to, and removed from, this list to
  /// arrive at [other].
  ///
  /// Example: `oldTags.diff(newTags)` → `(added: [...], removed: [...])`
  ({List<T> added, List<T> removed}) diff(Iterable<T> other) {
    final current = toSet();
    final target = other.toSet();
    return (added: target.where((e) => !current.contains(e)).toList(), removed: where((e) => !target.contains(e)).toList());
  }

  /// Returns a copy with [separator] inserted between every pair of elements,
  /// but not before the first or after the last.
  ///
  /// Named `intersperse` rather than `separatedBy` so it cannot shadow
  /// [ListxWidgetExtensions.separatedBy] on a homogeneous widget list such as
  /// `List<Text>`, where both extensions would otherwise apply.
  ///
  /// Example: `['a','b','c'].intersperse('-')` → `['a','-','b','-','c']`
  List<T> intersperse(T separator) {
    if (length < 2) return List<T>.from(this);
    final result = <T>[];
    for (var i = 0; i < length; i++) {
      if (i > 0) result.add(separator);
      result.add(this[i]);
    }
    return result;
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
