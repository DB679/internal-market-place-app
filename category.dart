// simple category model
class Category {
  final String id; // use id (like 'electronics') for filtering
  final String name;
  final String? iconAsset; // optional path to an icon asset

  Category({required this.id, required this.name, this.iconAsset});
}

final List<Category> appCategories = [
  Category(id: 'electronics', name: 'Electronics', iconAsset: null),
  Category(id: 'furniture', name: 'Furniture', iconAsset: null),
  Category(id: 'books', name: 'Books', iconAsset: null),
  Category(id: 'clothing', name: 'Clothing', iconAsset: null),
  Category(id: 'sports', name: 'Sports', iconAsset: null),
  Category(id: 'donations', name: 'Donations', iconAsset: null),
  Category(id: 'other', name: 'Other', iconAsset: null),
];
