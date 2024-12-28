import 'dart:collection';

/// LRU Cache Implementation
class LRUCache<K, V> {
  final int capacity;
  final LinkedHashMap<K, V> _cache = LinkedHashMap<K, V>();

  LRUCache(this.capacity);

  V? get(K key) {
    if (!_cache.containsKey(key)) return null;
    // Refresh the key by removing and re-inserting it
    final value = _cache.remove(key)!;
    _cache[key] = value;
    return value;
  }

  void set(K key, V value) {
    if (_cache.containsKey(key)) {
      _cache.remove(key);
    } else if (_cache.length >= capacity) {
      _cache.remove(_cache.keys.first);
    }
    _cache[key] = value;
  }

  void clear() => _cache.clear();

  bool containsKeyInCache(K key) => _cache.containsKey(key);
}
