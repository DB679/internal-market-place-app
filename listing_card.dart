import 'package:flutter/material.dart';
import 'listing.dart';
import 'wishlist_service.dart';
import 'dart:async';

class ListingCard extends StatefulWidget {
  final Listing item;
  final VoidCallback? onTap; // optional tap handler

  const ListingCard({super.key, required this.item, this.onTap});

  @override
  State<ListingCard> createState() => _ListingCardState();
}

class _ListingCardState extends State<ListingCard> {
  late bool _isFav;
  bool _loadingFav = false;
  StreamSubscription? _wishlistSubscription;

  @override
  void initState() {
    super.initState();

    // Defensive: if containsSync not available, fallback to false
    try {
      _isFav = WishlistService.instance.containsSync(widget.item.id);
    } catch (_) {
      _isFav = false;
    }

    // Listen to wishlist changes for real-time updates (if stream exists)
    try {
      final stream = WishlistService.instance.stream;
      _wishlistSubscription = stream.listen((_) {
        if (!mounted) return;
        try {
          final contains = WishlistService.instance.containsSync(widget.item.id);
          setState(() => _isFav = contains);
        } catch (_) {}
      });
    } catch (_) {
      // no stream available — ignore
    }
  }

  @override
  void dispose() {
    _wishlistSubscription?.cancel();
    super.dispose();
  }

  Future<void> _toggleFav() async {
    setState(() => _loadingFav = true);

    try {
      await WishlistService.instance.toggle(widget.item.id);
    } catch (_) {
      // If toggle not available, try add/remove API names used elsewhere
      try {
        if (_isFav) {
          await WishlistService.instance.remove(widget.item.id);
        } else {
          await WishlistService.instance.add(widget.item.id);
        }
      } catch (_) {}
    }

    if (!mounted) return;

    // update local state from service if possible
    try {
      final contains = WishlistService.instance.containsSync(widget.item.id);
      setState(() {
        _isFav = contains;
        _loadingFav = false;
      });
    } catch (_) {
      setState(() {
        _isFav = !_isFav;
        _loadingFav = false;
      });
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFav ? 'Added to wishlist' : 'Removed from wishlist'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final theme = Theme.of(context);
    final cardColor = theme.cardTheme.color ?? theme.colorScheme.surface;
    final textPrimary = theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onSurface;
    final textSecondary = theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurface.withOpacity(0.7);

    return Card(
      color: cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: theme.cardTheme.elevation ?? 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with favorite positioned
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.network(
                    item.imageUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // graceful fallback for 404 / network errors
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: theme.colorScheme.surface,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.broken_image,
                          size: 48,
                          color: theme.disabledColor,
                        ),
                      );
                    },
                  ),
                ),

                // favorite icon
                Positioned(
                  right: 8,
                  top: 8,
                  child: _loadingFav
                      ? const SizedBox(
                          width: 36,
                          height: 36,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : GestureDetector(
                          onTap: _toggleFav,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9), // fixed
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              _isFav ? Icons.favorite : Icons.favorite_outline,
                              color: _isFav ? Colors.red : Colors.black54,
                              size: 20,
                            ),
                          ),
                        ),
                ),
              ],
            ),

            // rest of card content
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.isDonation)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "DONATION",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),

                  const SizedBox(height: 6),

                  Text(
                    item.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimary),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item.isDonation ? "FREE" : "₹ ${item.price}",
                    style: TextStyle(
                      fontSize: 15,
                      color: item.isDonation ? Colors.green : textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: textSecondary),
                      const SizedBox(width: 6),
                      Expanded(child: Text(item.location, style: TextStyle(color: textSecondary))),
                      Text(item.date, style: TextStyle(color: textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
