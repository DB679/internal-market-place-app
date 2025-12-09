import 'package:flutter/material.dart';
import 'dart:async';
import 'notification_service.dart';
import 'app_notification.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // Listen to notification changes
    _subscription = NotificationService.instance.stream.listen((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationService.instance.all;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                NotificationService.instance.markAllRead();
                setState(() {});
              },
              child: const Text(
                "Mark all read",
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No notifications",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final AppNotification n = notifications[index];
                return Container(
                  color: n.read ? Colors.transparent : Colors.blue.withValues(alpha: 0.05),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: n.read ? Colors.grey : Colors.blue,
                      child: Icon(
                        n.read ? Icons.notifications : Icons.notifications_active,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      n.title,
                      style: TextStyle(
                        fontWeight: n.read ? FontWeight.normal : FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(n.message),
                    trailing: Text(
                      DateFormat.jm().format(n.time),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    onTap: () {
                      NotificationService.instance.markRead(n.id);
                      setState(() {});
                    },
                  ),
                );
              },
            ),
    );
  }
}