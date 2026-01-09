class Listing {
  final String id;
  final String title;
  final String imageUrl;
  final int price;
  final String location;
  final String date;
  final String category;
  final bool isDonation;

  // Backend related (optional)
  final String? listingType;
  final String? status;
  final String? listedBy;
  final DateTime? createdAt;

  Listing({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.date,
    required this.category,
    this.isDonation = false,
    this.listingType,
    this.status,
    this.listedBy,
    this.createdAt,
  });

  // 🔥 BACKEND → UI SAFE MAPPER
  factory Listing.fromJson(Map<String, dynamic> json) {
    final created = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now();

    final type = json['listing_type'] ?? 'sell';

    return Listing(
      id: json['id'].toString(), // UI still expects String
      title: json['title'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      price: json['price'] != null
          ? double.parse(json['price'].toString()).toInt()
          : 0,
      location: json['location'] ?? '',
      category: json['category'] ?? '',
      date: created.toIso8601String().split('T').first,
      isDonation: type == 'donate',
      listingType: type,
      status: json['status'],
      listedBy: json['listed_by'],
      createdAt: created,
    );
  }

  // 👇 KEEP OLD METHODS (prevents 83 errors)

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'location': location,
      'date': date,
      'category': category,
      'isDonation': isDonation,
    };
  }

  Listing copyWith({
    String? id,
    String? title,
    String? imageUrl,
    int? price,
    String? location,
    String? date,
    String? category,
    bool? isDonation,
  }) {
    return Listing(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      location: location ?? this.location,
      date: date ?? this.date,
      category: category ?? this.category,
      isDonation: isDonation ?? this.isDonation,
      listingType: listingType,
      status: status,
      listedBy: listedBy,
      createdAt: createdAt,
    );
  }
}
