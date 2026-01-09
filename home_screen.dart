import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'listing_card.dart';
import 'listing_detail_page.dart';
import 'notification_page.dart';
import 'notification_service.dart';
import 'package:flutter_application_1/services/listing_provider.dart';


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
  String _sortBy = 'newest';

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

  @override
  void initState() {
    super.initState();
    // Fetch approved listings when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ListingProvider>().fetchApproved();
    });
  }

  List<dynamic> get _filteredListings {
    final provider = context.read<ListingProvider>();
    List<dynamic> filtered = provider.approvedListings;

    if (_selectedCategory != 'All') {
      filtered = filtered.where((l) => l.category == _selectedCategory).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((l) {
        return l.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (l.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      }).toList();
    }

    switch (_sortBy) {
      case 'newest':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.date.compareTo(b.date));
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<ListingProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Company Marketplace'),
            actions: [
              IconButton(
                icon: Stack(
                  children: [
                    const Icon(Icons.notifications_outlined),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPage(),
                    ),
                  );
                },
              ),
              if (widget.themeToggleButton != null)
                Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 16.0),
                  child: Center(child: widget.themeToggleButton!),
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => provider.fetchApproved(),
            child: Column(
              children: [
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

                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
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
                              child: FilterChip(
                                label: Text(category),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedCategory = category;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.sort),
                          onSelected: (String value) {
                            setState(() {
                              _sortBy = value;
                            });
                          },
                          itemBuilder: (BuildContext context) => [
                            const PopupMenuItem(
                              value: 'newest',
                              child: Text('Newest First'),
                            ),
                            const PopupMenuItem(
                              value: 'oldest',
                              child: Text('Oldest First'),
                            ),
                            const PopupMenuItem(
                              value: 'price_low',
                              child: Text('Price: Low to High'),
                            ),
                            const PopupMenuItem(
                              value: 'price_high',
                              child: Text('Price: High to Low'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: provider.loadingApproved && provider.approvedListings.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : _filteredListings.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    size: 64,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No items found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.85,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: _filteredListings.length,
                              itemBuilder: (context, index) {
                                return ListingCard(
                                  item: _filteredListings[index],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>ListingDetailPage(listing: listing),
                                        ),
                                      ),
                                    ).then((_) {
                                      provider.fetchApproved();
                                    });
                                  },
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}