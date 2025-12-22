import 'package:flutter/material.dart';
import 'listing.dart';
import 'wishlist_service.dart';
import 'dart:async';

class ListingDetailPage extends StatefulWidget {
  final Listing listing;
  final bool showInquiry;

  const ListingDetailPage({super.key, required this.listing, this.showInquiry = true});

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  late bool _isFav;
  StreamSubscription? _wishlistSubscription;

  @override
  void initState() {
    super.initState();
    _isFav = WishlistService.instance.containsSync(widget.listing.id);
    
    _wishlistSubscription = WishlistService.instance.stream.listen((_) {
      if (mounted) {
        setState(() {
          _isFav = WishlistService.instance.containsSync(widget.listing.id);
        });
      }
    });
  }

  @override
  void dispose() {
    _wishlistSubscription?.cancel();
    super.dispose();
  }

  Future<void> _toggleWishlist() async {
    await WishlistService.instance.toggle(widget.listing.id);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isFav ? 'Added to wishlist' : 'Removed from wishlist'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final listing = widget.listing;
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                listing.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50),
                  );
                },
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isFav ? Icons.favorite : Icons.favorite_outline,
                  color: _isFav ? Colors.red : Colors.white,
                ),
                onPressed: _toggleWishlist,
              ),
            ],
          ),

          // Content
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Donation badge
                    if (listing.isDonation)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "FREE DONATION",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      listing.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Price
                    Text(
                      listing.isDonation ? "FREE" : "₹ ${listing.price}",
                      style: TextStyle(
                        fontSize: 28,
                        color: listing.isDonation ? Colors.green : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Location and Date
                    Row(
                      children: [
                        const Icon(Icons.location_on, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            listing.location,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Text(
                          listing.date,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Description Section
                    const Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      listing.description ?? "No description available.",
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 24),
                    // Contact Information (includes seller name, department, phone and email)
                    const Text(
                      "Contact Information",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Name + Department
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person, color: Colors.black54),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(listing.sellerName ?? 'Unknown Seller', style: const TextStyle(fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text(listing.sellerDepartment ?? 'Department not specified', style: const TextStyle(color: Colors.black54)),
                            ],
                          ),
                        ),
                        // removed right-side contact button per design
                      ],
                    ),

                    const SizedBox(height: 12),
                    // Phone
                    if (listing.sellerPhone != null)
                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(listing.sellerPhone!),
                        ],
                      ),
                    const SizedBox(height: 8),
                    // Email
                    if (listing.sellerEmail != null)
                      Row(
                        children: [
                          const Icon(Icons.email, color: Colors.black54),
                          const SizedBox(width: 8),
                          Text(listing.sellerEmail!),
                        ],
                      ),

                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 16),

                    // Category
                    Row(
                      children: [
                        const Text(
                          "Category: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          listing.category,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // (Removed seller card) Seller details now shown under Contact Information below


                    // Contact Button
                    if (widget.showInquiry)
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final seller = listing.sellerName ?? 'the seller';
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Inquiry sent to $seller'),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.message),
                          label: const Text(
                            'Send Inquiry',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}