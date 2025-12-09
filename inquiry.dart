// simple UI model for inquiry
class Inquiry {
  final String id;
  final String listingId;
  final String listingTitle;
  final String buyerName;
  final String buyerContact; // email or phone (mock)
  final String message;
  final DateTime createdAt;
  bool read;
  bool handled;

  Inquiry({
    required this.id,
    required this.listingId,
    required this.listingTitle,
    required this.buyerName,
    required this.buyerContact,
    required this.message,
    DateTime? createdAt,
    this.read = false,
    this.handled = false,
  }) : createdAt = createdAt ?? DateTime.now();
}
