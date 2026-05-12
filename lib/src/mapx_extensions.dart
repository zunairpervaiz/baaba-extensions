extension MapX<K, V> on Map<K, V> {
  /// Returns the value for [key], or [defaultValue] when the key is absent.
  ///
  /// Example: `map.getOrDefault('missing', 'fallback')` → `'fallback'`
  V getOrDefault(K key, V defaultValue) => this[key] ?? defaultValue;

  /// Returns a new map with every value transformed by [transform].
  ///
  /// Example: `{'a': 1, 'b': 2}.mapValues((v) => v * 2)` → `{'a': 2, 'b': 4}`
  Map<K, R> mapValues<R>(R Function(V value) transform) =>
      map((k, v) => MapEntry(k, transform(v)));

  /// Returns a new map containing only entries whose key satisfies [predicate].
  ///
  /// Example: `map.filterKeys((k) => k.startsWith('x'))`
  Map<K, V> filterKeys(bool Function(K key) predicate) =>
      Map.fromEntries(entries.where((e) => predicate(e.key)));

  /// Returns a new map containing only entries whose value satisfies [predicate].
  ///
  /// Example: `map.filterValues((v) => v > 0)`
  Map<K, V> filterValues(bool Function(V value) predicate) =>
      Map.fromEntries(entries.where((e) => predicate(e.value)));

  /// Converts every key-value pair to a [T] using [transform] and returns the list.
  ///
  /// Example: `{'a': 1}.toListX((k, v) => '$k=$v')` → `['a=1']`
  List<T> toListX<T>(T Function(K key, V value) transform) =>
      entries.map((e) => transform(e.key, e.value)).toList();

  /// Returns a new map that is the result of merging this map with [other].
  /// When both maps contain the same key, [resolve] is called with the existing
  /// and incoming values; if [resolve] is null, the incoming value wins.
  Map<K, V> mergeWith(
    Map<K, V> other, {
    V Function(V existing, V incoming)? resolve,
  }) {
    final result = Map<K, V>.from(this);
    for (final entry in other.entries) {
      result[entry.key] = result.containsKey(entry.key) && resolve != null
          ? resolve(result[entry.key] as V, entry.value)
          : entry.value;
    }
    return result;
  }

  /// Returns a new map with keys and values swapped.
  ///
  /// Example: `{'a': 1, 'b': 2}.inverse` → `{1: 'a', 2: 'b'}`
  Map<V, K> get inverse => map((k, v) => MapEntry(v, k));
}
