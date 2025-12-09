import 'package:flutter/material.dart';
import 'listing.dart';
import 'listing_card.dart';
import 'listing_detail_page.dart';
import 'notification_page.dart';
import 'notification_service.dart';

class HomeScreen extends StatefulWidget {
  final Widget? themeToggleButton;

  const HomeScreen({
    super.key,
    this.themeToggleButton,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  String _sortBy = 'newest'; // newest, oldest, price_low, price_high

  final List<String> _categories = [
    'All',
    'Electronics',
    'Furniture',
    'Books',
    'Clothing',
    'Sports',
    'Donations',
    'Other',
  ];

  List<Listing> get _filteredListings {
    List<Listing> filtered = demoListings;

    // Filter by category
    if (_selectedCategory != 'All') {
      if (_selectedCategory == 'Donations') {
        filtered = filtered.where((l) => l.isDonation).toList();
      } else {
        filtered = filtered.where((l) => l.category == _selectedCategory).toList();
      }
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((l) {
        return l.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (l.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    // Sort listings
    switch (_sortBy) {
      case 'newest':
        // Assuming 'Today' > 'Yesterday' > '2 days ago'
        filtered.sort((a, b) => _compareDates(a.date, b.date));
        break;
      case 'oldest':
        filtered.sort((a, b) => _compareDates(b.date, a.date));
        break;
      case 'price_low':
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_high':
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;
    }

    return filtered;
  }

  int _compareDates(String dateA, String dateB) {
    // Simple date comparison - you can improve this
    const dateOrder = {
      'Today': 0,
      'Yesterday': 1,
      '2 days ago': 2,
      '3 days ago': 3,
      '4 days ago': 4,
      '5 days ago': 5,
      '6 days ago': 6,
      'Last week': 7,
    };
    return (dateOrder[dateA] ?? 999).compareTo(dateOrder[dateB] ?? 999);
  }

  void _showSortOptions(BuildContext context) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.sort, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Sort By',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 20),
            // Sort options
            _buildSortOption(
              context,
              'Newest First',
              'newest',
              Icons.access_time,
            ),
            _buildSortOption(
              context,
              'Oldest First',
              'oldest',
              Icons.history,
            ),
            _buildSortOption(
              context,
              'Price: Low to High',
              'price_low',
              Icons.arrow_upward,
            ),
            _buildSortOption(
              context,
              'Price: High to Low',
              'price_high',
              Icons.arrow_downward,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(
    BuildContext context,
    String title,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    final isSelected = _sortBy == value;

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.secondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected ? theme.colorScheme.primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
          : null,
      onTap: () {
        setState(() {
          _sortBy = value;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Marketplace'),
        actions: [
          // Notification Bell Icon
          IconButton(
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined),
                // Show unread count badge
                if (NotificationService.instance.unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '${NotificationService.instance.unreadCount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            onPressed: () {
              // Navigate to notifications page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationPage(),
                ),
              ).then((_) => setState(() {})); // refresh badge after return
            },
          ),
          // Theme Toggle Button
          if (widget.themeToggleButton != null)
            Padding(
              padding: const EdgeInsets.only(left: 4.0, right: 16.0),
              child: Center(child: widget.themeToggleButton!),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: theme.inputDecorationTheme.fillColor ?? Colors.grey[100],
              ),
            ),
          ),

          // Category Tabs with Sort Button
          SizedBox(
            height: 50,
            child: Row(
              children: [
                // Categories List
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 12),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = category == _selectedCategory;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                          selectedColor: theme.colorScheme.primary,
                          backgroundColor: theme.cardTheme.color ?? theme.colorScheme.surface,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Sort Button
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 12),
                  child: Material(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    elevation: 2,
                    child: InkWell(
                      onTap: () => _showSortOptions(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.sort,
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Sort',
                              style: TextStyle(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Section Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest Listings',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${_filteredListings.length} items',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Listings Grid/List
          Expanded(
            child: _filteredListings.isEmpty
                ? Center(
                    child: Text('No listings found', style: theme.textTheme.bodyLarge),
                  )
                : ListView.builder(
                    itemCount: _filteredListings.length,
                    itemBuilder: (context, index) {
                      final listing = _filteredListings[index];
                      return ListingCard(
                        item: listing,
                        onTap: () {
                          // Navigate to detail page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListingDetailPage(listing: listing),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// Example demo data - replace this with your actual data source
final List<Listing> demoListings = [
  Listing(
    id: '1',
    title: 'Office Chair - Good Condition',
    imageUrl: 'https://images.pexels.com/photos/374746/pexels-photo-374746.jpeg',
    price: 1500,
    location: 'Head Office, Floor 3',
    date: 'Today',
    category: 'Furniture',
    description: 'Comfortable office chair in good condition. Adjustable height and armrests. Perfect for home office setup.',
  ),
  Listing(
    id: '2',
    title: 'Dell Monitor 24 inch',
    imageUrl: 'https://images.pexels.com/photos/777001/pexels-photo-777001.jpeg',
    price: 5000,
    location: 'IT Department, Floor 2',
    date: 'Yesterday',
    category: 'Electronics',
    description: 'Full HD Dell monitor, 24 inches. Excellent display quality. Used for 2 years, no scratches or dead pixels.',
  ),
  Listing(
    id: '3',
    title: 'Programming Books Set',
    imageUrl: 'https://images.pexels.com/photos/1370295/pexels-photo-1370295.jpeg',
    price: 800,
    location: 'Library, Floor 1',
    date: '2 days ago',
    category: 'Books',
    description: 'Collection of programming books including Python, JavaScript, and Data Structures. Great for beginners.',
  ),
  Listing(
    id: '4',
    title: 'Free Office Supplies',
    imageUrl: 'https://images.pexels.com/photos/265672/pexels-photo-265672.jpeg',
    price: 0,
    location: 'Storage Room',
    date: 'Today',
    category: 'Other',
    isDonation: true,
    description: 'Various office supplies including pens, notebooks, folders. Free to anyone who needs them.',
  ),
];