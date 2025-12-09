class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  bool read;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    DateTime? time,
    this.read = false,
  }) : time = time ?? DateTime.now();
}
