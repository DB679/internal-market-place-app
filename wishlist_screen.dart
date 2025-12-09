import 'package:flutter/material.dart';
import 'dart:async';
import 'wishlist_service.dart';
import 'listing.dart';
import 'listing_card.dart';
import 'listing_detail_page.dart';

// Temporary: Define demo listings here until you have a proper data source
final List<Listing> demoListings = [
  Listing(
    id: '1',
    title: 'Office Chair - Good Condition',
    imageUrl: 'https://images.pexels.com/photos/276534/pexels-photo-276534.jpeg',
    price: 1500,
    location: 'Head Office, Floor 3',
    date: 'Today',
    category: 'Furniture',
    description: 'Comfortable office chair in good condition.',
  ),
  Listing(
    id: '2',
    title: 'Dell Monitor 24 inch',
    imageUrl: 'https://images.pexels.com/photos/777001/pexels-photo-777001.jpeg',
    price: 5000,
    location: 'IT Department, Floor 2',
    date: 'Yesterday',
    category: 'Electronics',
    description: 'Full HD Dell monitor, 24 inches.',
  ),
  Listing(
    id: '3',
    title: 'Programming Books Set',
    imageUrl: 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg',
    price: 800,
    location: 'Library, Floor 1',
    date: '2 days ago',
    category: 'Books',
    description: 'Collection of programming books.',
  ),
];

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Listing> _items = [];
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _load();
    
    // Listen to wishlist changes in real-time
    _subscription = WishlistService.instance.stream.listen((_) {
      _load();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    final ids = await WishlistService.instance.allAsync;
    // Filter demo listings by wishlist IDs
    _items = demoListings.where((l) => ids.contains(l.id)).toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              await WishlistService.instance.clear();
              if (mounted) {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Wishlist cleared')),
                );
              }
            },
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final l = _items[index];
                return ListingCard(
                  item: l,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ListingDetailPage(listing: l),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}