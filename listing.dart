class Listing {
  final String id;
  final String title;
  final String imageUrl;
  final int price;
  final String location;
  final String date;
  final String category;
  final bool isDonation;
  final String? description;

  Listing({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.location,
    required this.date,
    required this.category,
    this.isDonation = false,
    this.description,
  });

  // Convert to JSON
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
    };
  }

  // Create from JSON
  factory Listing.fromJson(Map<String, dynamic> json) {
    return Listing(
      id: json['id'] as String,
      title: json['title'] as String,
      imageUrl: json['imageUrl'] as String,
      price: json['price'] as int,
      location: json['location'] as String,
      date: json['date'] as String,
      category: json['category'] as String,
      isDonation: json['isDonation'] as bool? ?? false,
      description: json['description'] as String?,
    );
  }

  // Create a copy with some fields updated
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
      description: description ?? this.description,
    );
  }
}