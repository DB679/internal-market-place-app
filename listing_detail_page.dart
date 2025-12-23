import 'package:flutter/material.dart';
import 'listing.dart';
import 'wishlist_service.dart';
import 'inquiry_service.dart';
import '../../../../services/user_service.dart';
import 'dart:async';

class ListingDetailPage extends StatefulWidget {
  final Listing listing;
  final bool showInquiry;
  final bool showAdminActions;

  const ListingDetailPage({super.key, required this.listing, this.showInquiry = true, this.showAdminActions = false});

  @override
  State<ListingDetailPage> createState() => _ListingDetailPageState();
}

class _ListingDetailPageState extends State<ListingDetailPage> {
  late bool _isFav;
  StreamSubscription? _wishlistSubscription;
  late bool _inquirySent;

  @override
  void initState() {
    super.initState();
    _isFav = WishlistService.instance.containsSync(widget.listing.id);
    _inquirySent = InquiryService.instance.all.any((i) => i.listingId == widget.listing.id);
    
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

  Future<void> _showInquiryDialog() async {
    final nameCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final messageCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final sent = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Inquiry'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Your name'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
                ),
                TextFormField(
                  controller: contactCtrl,
                  decoration: const InputDecoration(labelText: 'Contact (email or phone)'),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter contact' : null,
                ),
                TextFormField(
                  controller: messageCtrl,
                  decoration: const InputDecoration(labelText: 'Message (optional)'),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                InquiryService.instance.addInquiry(
                  listingId: widget.listing.id,
                  listingTitle: widget.listing.title,
                  buyerName: nameCtrl.text.trim(),
                  buyerContact: contactCtrl.text.trim(),
                  message: messageCtrl.text.trim(),
                );
                Navigator.of(context).pop(true);
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (sent == true && mounted) {
      final seller = widget.listing.sellerName ?? 'the seller';
      // mark sent so button disables
      setState(() {
        _inquirySent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inquiry sent to $seller')),
      );
    }
  }

  Future<void> _sendInquiryAuto() async {
    final user = UserService.instance;
    if (!user.isLoggedIn) {
      // fallback to dialog if no profile
      await _showInquiryDialog();
      return;
    }

    InquiryService.instance.addInquiry(
      listingId: widget.listing.id,
      listingTitle: widget.listing.title,
      buyerName: user.name,
      buyerContact: user.contact,
      message: 'Automated enquiry: please contact me.',
    );

    if (mounted) {
      setState(() {
        _inquirySent = true;
      });
      final seller = widget.listing.sellerName ?? 'the seller';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inquiry sent to $seller')),
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
                        child: _inquirySent
                            ? ElevatedButton.icon(
                                onPressed: null,
                                icon: const Icon(Icons.check, color: Colors.white),
                                label: const Text('Enquiry Sent', style: TextStyle(fontSize: 16)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              )
                                : ElevatedButton.icon(
                                onPressed: () async {
                                  await _sendInquiryAuto();
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

                    // Admin actions: Accept / Reject directly from expanded view
                    if (widget.showAdminActions)
                      Column(
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'accepted');
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Text('Accept', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, 'rejected');
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: Text('Reject', style: TextStyle(color: Colors.white)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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