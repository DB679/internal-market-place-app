import 'package:flutter/material.dart';

class WishlistProvider extends ChangeNotifier {
  final List<String> _wishlistIds = [];

  List<String> get items => _wishlistIds;

  bool contains(String id) {
    return _wishlistIds.contains(id);
  }

  void toggle(String id) {
    if (_wishlistIds.contains(id)) {
      _wishlistIds.remove(id);
    } else {
      _wishlistIds.add(id);
    }
    notifyListeners();
  }

  void add(String id) {
    if (!_wishlistIds.contains(id)) {
      _wishlistIds.add(id);
      notifyListeners();
    }
  }

  void remove(String id) {
    if (_wishlistIds.remove(id)) {
      notifyListeners();
    }
  }

  void clear() {
    _wishlistIds.clear();
    notifyListeners();
  }
}
