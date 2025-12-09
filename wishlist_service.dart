import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistService {
  static final WishlistService instance = WishlistService._();
  WishlistService._();

  final String _key = 'wishlist_ids';
  final _controller = StreamController<List<String>>.broadcast();
  
  // Stream that other widgets can listen to for real-time updates
  Stream<List<String>> get stream => _controller.stream;

  List<String> _cachedIds = [];
  bool _initialized = false;

  // Lazy initialization - automatically called when needed
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _cachedIds = prefs.getStringList(_key) ?? [];
    _initialized = true;
  }

  // Get all wishlist IDs
  Future<List<String>> get allAsync async {
    await _ensureInitialized();
    return _cachedIds;
  }

  // Synchronous getter (use after initialization)
  List<String> get all => _cachedIds;

  // Check if an item is in the wishlist
  Future<bool> contains(String id) async {
    await _ensureInitialized();
    return _cachedIds.contains(id);
  }

  // Check synchronously (use after initialization)
  bool containsSync(String id) {
    return _cachedIds.contains(id);
  }

  // Add an item to the wishlist
  Future<void> add(String id) async {
    await _ensureInitialized();
    if (!_cachedIds.contains(id)) {
      _cachedIds.add(id);
      await _save();
      _controller.add(_cachedIds); // Notify listeners
    }
  }

  // Remove an item from the wishlist
  Future<void> remove(String id) async {
    await _ensureInitialized();
    _cachedIds.remove(id);
    await _save();
    _controller.add(_cachedIds); // Notify listeners
  }

  // Toggle an item in the wishlist
  Future<void> toggle(String id) async {
    await _ensureInitialized();
    if (_cachedIds.contains(id)) {
      await remove(id);
    } else {
      await add(id);
    }
  }

  // Clear all items from the wishlist
  Future<void> clear() async {
    await _ensureInitialized();
    _cachedIds.clear();
    await _save();
    _controller.add(_cachedIds); // Notify listeners
  }

  // Save to SharedPreferences
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _cachedIds);
  }

  // Clean up the stream controller
  void dispose() {
    _controller.close();
  }
}