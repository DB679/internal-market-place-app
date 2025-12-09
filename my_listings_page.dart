import 'package:flutter/material.dart';

class MyListingsPage extends StatelessWidget {
  const MyListingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final background = const Color(0xFFF5EFE7);

    // Static sample data for now (replace with Supabase later)
    final listings = [
      {
        'title': 'Ergonomic Office Chair',
        'type': 'Sell',
        'price': 2500,
        'isDonation': false,
        'status': 'Active',
      },
      {
        'title': 'Mechanical Keyboard',
        'type': 'Donation',
        'price': 0,
        'isDonation': true,
        'status': 'Active',
      },
      {
        'title': 'Projector (Meeting Room)',
        'type': 'Rent',
        'price': 500,
        'isDonation': false,
        'status': 'Inactive',
      },
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3C3C),
        title: const Text('My Listings'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: listings.length,
        itemBuilder: (context, index) {
          final item = listings[index];
          final String title = item['title'] as String;
          final String type = item['type'] as String;
          final bool isDonation = item['isDonation'] as bool;
          final int price = item['price'] as int;
          final String status = item['status'] as String;
          final bool isActive = status.toLowerCase() == 'active';

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text('Type: $type'),
                  const SizedBox(height: 2),
                  if (isDonation)
                    const Text('Donation (Free)')
                  else
                    Text('Price: ₹$price'),
                  const SizedBox(height: 4),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      color: isActive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Later: open listing detail / edit page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Open details for "$title" (TODO)'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
