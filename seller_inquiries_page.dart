import 'package:flutter/material.dart';
import 'inquiry_service.dart';
import 'inquiry.dart';
import 'package:intl/intl.dart';

class SellerInquiriesPage extends StatefulWidget {
  const SellerInquiriesPage({super.key});

  @override
  State<SellerInquiriesPage> createState() => _SellerInquiriesPageState();
}

class _SellerInquiriesPageState extends State<SellerInquiriesPage> {
  @override
  Widget build(BuildContext context) {
    final List<Inquiry> items = InquiryService.instance.all;

    return Scaffold(
      appBar: AppBar(title: const Text('Seller Inquiries')),
      body: items.isEmpty
          ? const Center(child: Text('No inquiries yet.'))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final inq = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(inq.listingTitle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${inq.buyerName} • ${inq.buyerContact}'),
                        const SizedBox(height: 6),
                        Text(inq.message.isEmpty ? '(no message)' : inq.message),
                        const SizedBox(height: 6),
                        Text(DateFormat.yMMMd().add_jm().format(inq.createdAt), style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(inq.read ? Icons.mark_email_read : Icons.mark_email_unread),
                          onPressed: () {
                            setState(() {
                              InquiryService.instance.markRead(inq.id);
                            });
                          },
                          tooltip: inq.read ? 'Mark unread' : 'Mark read',
                        ),
                        IconButton(
                          icon: Icon(inq.handled ? Icons.check_circle : Icons.check_circle_outline, color: inq.handled ? Colors.green : null),
                          onPressed: () {
                            setState(() {
                              InquiryService.instance.markHandled(inq.id);
                            });
                          },
                          tooltip: inq.handled ? 'Handled' : 'Mark handled',
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Clear'),
        icon: const Icon(Icons.delete_sweep),
        onPressed: () {
          InquiryService.instance.clearAll();
          setState(() {});
        },
      ),
    );
  }
}
