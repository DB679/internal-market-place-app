class Listing {
  final String id;
  final String title;
  final String imageUrl;
  final int price;
  final String location;
  final String date;
  final String category;
  final bool isDonation;

  // 🔹 Backend-related
  final String? listingType;
  final String? status;
  final String? listedBy;
  final DateTime? createdAt;

  // 🔹 UI-only fields (needed by detail & wishlist pages)
  final String? description;
  final String? sellerName;
  final String? sellerDepartment;
  final String? sellerPhone;
  final String? sellerEmail;

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
    this.description,
    this.sellerName,
    this.sellerDepartment,
    this.sellerPhone,
    this.sellerEmail,
  });

  // 🔥 BACKEND → UI SAFE MAPPER
  factory Listing.fromJson(Map<String, dynamic> json) {
    final created = json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : DateTime.now();

    final type = json['listing_type'] ?? 'sell';

    return Listing(
      id: json['id'].toString(),
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

      // UI-safe optional fields
      description: json['description'],
      sellerName: json['seller_name'],
      sellerDepartment: json['seller_department'],
      sellerPhone: json['seller_phone'],
      sellerEmail: json['seller_email'],
    );
  }

  // 👇 Keep old helpers to avoid cascading UI errors
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
      'description': description,
      'sellerName': sellerName,
      'sellerDepartment': sellerDepartment,
      'sellerPhone': sellerPhone,
      'sellerEmail': sellerEmail,
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
    String? description,
    String? sellerName,
    String? sellerDepartment,
    String? sellerPhone,
    String? sellerEmail,
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
      description: description ?? this.description,
      sellerName: sellerName ?? this.sellerName,
      sellerDepartment: sellerDepartment ?? this.sellerDepartment,
      sellerPhone: sellerPhone ?? this.sellerPhone,
      sellerEmail: sellerEmail ?? this.sellerEmail,
    );
  }
}
