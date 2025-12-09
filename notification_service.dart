import 'dart:async';
import 'package:uuid/uuid.dart';
import 'app_notification.dart';

class NotificationService {
  NotificationService._private();
  static final NotificationService instance = NotificationService._private();

  final List<AppNotification> _items = [];
  final _controller = StreamController<List<AppNotification>>.broadcast();

  // Stream that other widgets can listen to for real-time updates
  Stream<List<AppNotification>> get stream => _controller.stream;

  List<AppNotification> get all => List.unmodifiable(_items.reversed);

  int get unreadCount => _items.where((n) => !n.read).length;

  void add(String title, String message) {
    _items.add(
      AppNotification(
        id: const Uuid().v4(),
        title: title,
        message: message,
      ),
    );
    _controller.add(_items); // Notify listeners
  }

  void markRead(String id) {
    final index = _items.indexWhere((e) => e.id == id);
    if (index != -1) {
      _items[index].read = true;
      _controller.add(_items); // Notify listeners
    }
  }

  void markAllRead() {
    for (var n in _items) {
      n.read = true;
    }
    _controller.add(_items); // Notify listeners
  }

  void dispose() {
    _controller.close();
  }
}