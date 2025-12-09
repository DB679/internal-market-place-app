import 'package:uuid/uuid.dart';
import 'inquiry.dart';

/// Very small in-memory service to store inquiries for UI/demo purposes.
/// Replace this with API calls when backend is ready.
class InquiryService {
  InquiryService._private();
  static final InquiryService instance = InquiryService._private();

  final List<Inquiry> _inquiries = [];

  List<Inquiry> get all => List.unmodifiable(_inquiries.reversed);

  void addInquiry({
    required String listingId,
    required String listingTitle,
    required String buyerName,
    required String buyerContact,
    required String message,
  }) {
    final id = const Uuid().v4();
    final inq = Inquiry(
      id: id,
      listingId: listingId,
      listingTitle: listingTitle,
      buyerName: buyerName,
      buyerContact: buyerContact,
      message: message,
    );
    _inquiries.add(inq);
  }

  void markRead(String inquiryId) {
    final i = _inquiries.indexWhere((x) => x.id == inquiryId);
    if (i >= 0) _inquiries[i].read = true;
  }

  void markHandled(String inquiryId) {
    final i = _inquiries.indexWhere((x) => x.id == inquiryId);
    if (i >= 0) _inquiries[i].handled = true;
  }

  void clearAll() => _inquiries.clear();
}
