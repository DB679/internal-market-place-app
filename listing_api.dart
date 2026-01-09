import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ListingApi {
  static const String baseUrl = const String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:8000/api');

  // ==================== LISTING ENDPOINTS ====================

  /// Fetch all approved listings
  static Future<List<dynamic>> fetchApprovedListings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listings/approved/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load approved listings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching approved listings: $e');
      rethrow;
    }
  }

  /// Fetch pending listings (Admin only)
  static Future<List<dynamic>> fetchPendingListings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listings/pending/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load pending listings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching pending listings: $e');
      rethrow;
    }
  }

  /// Fetch user's own listings
  static Future<List<dynamic>> fetchMyListings({required String listedBy}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/listings/my/?listed_by=$listedBy'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load my listings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching my listings: $e');
      rethrow;
    }
  }

  /// Create new listing with optional images
  static Future<Map<String, dynamic>> createListing({
    required String title,
    required String description,
    required String listingType,
    double? price,
    required String listedBy,
    List<String>? imagePaths,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/listings/create/');

      if (imagePaths != null && imagePaths.isNotEmpty) {
        final request = http.MultipartRequest('POST', uri);
        request.fields['title'] = title;
        request.fields['description'] = description;
        request.fields['listing_type'] = listingType.toLowerCase();
        if (price != null) request.fields['price'] = price.toString();
        request.fields['listed_by'] = listedBy;

        for (final imagePath in imagePaths) {
          final file = File(imagePath);
          if (file.existsSync()) {
            request.files.add(
              await http.MultipartFile.fromPath('images', imagePath),
            );
          }
        }

        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          return jsonDecode(responseBody) as Map<String, dynamic>;
        } else {
          throw Exception('Failed to create listing: ${response.statusCode} $responseBody');
        }
      } else {
        final response = await http.post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'title': title,
            'description': description,
            'listing_type': listingType.toLowerCase(),
            'price': price,
            'listed_by': listedBy,
          }),
        );

        if (response.statusCode == 201) {
          return jsonDecode(response.body) as Map<String, dynamic>;
        } else {
          throw Exception('Failed to create listing: ${response.statusCode} ${response.body}');
        }
      }
    } catch (e) {
      print('Error creating listing: $e');
      rethrow;
    }
  }

  /// Update listing status (approve/reject)
  static Future<Map<String, dynamic>> updateListingStatus(int id, String action) async {
    try {
      final endpoint = (action == 'approve') ? 'approve' : 'reject';
      final response = await http.patch(
        Uri.parse('$baseUrl/listings/$id/$endpoint/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to update listing status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating listing status: $e');
      rethrow;
    }
  }

  /// Delete listing
  static Future<bool> deleteListing(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/listings/$id/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete listing: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting listing: $e');
      rethrow;
    }
  }

  // ==================== ADMIN ENDPOINTS ====================

  /// Get admin statistics
  static Future<Map<String, dynamic>> fetchAdminStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/admin/stats/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to load admin stats: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching admin stats: $e');
      rethrow;
    }
  }

  // ==================== INQUIRY ENDPOINTS ====================

  /// Create an inquiry for a listing
  static Future<Map<String, dynamic>> createInquiry({
    required int listingId,
    required String inquiredBy,
    required String message,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/inquiries/create/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'listing': listingId,
          'inquired_by': inquiredBy,
          'message': message,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to create inquiry: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating inquiry: $e');
      rethrow;
    }
  }

  /// Fetch inquiries for a listing
  static Future<List<dynamic>> fetchInquiriesForListing(int listingId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inquiries/listing/$listingId/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load inquiries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching inquiries: $e');
      rethrow;
    }
  }

  /// Fetch seller's received inquiries
  static Future<List<dynamic>> fetchMyReceivedInquiries(String sellerName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/inquiries/seller/$sellerName/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load received inquiries: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching received inquiries: $e');
      rethrow;
    }
  }

  /// Reply to an inquiry
  static Future<Map<String, dynamic>> replyToInquiry(int inquiryId, String reply) async {
    try {
      final response = await http.patch(
        Uri.parse('$baseUrl/inquiries/$inquiryId/reply/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'reply': reply}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Failed to reply to inquiry: ${response.statusCode}');
      }
    } catch (e) {
      print('Error replying to inquiry: $e');
      rethrow;
    }
  }

  // ==================== WISHLIST ENDPOINTS ====================

  /// Add item to wishlist
  static Future<bool> addToWishlist(String username, int listingId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/wishlist/add/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user': username,
          'listing': listingId,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Error adding to wishlist: $e');
      rethrow;
    }
  }

  /// Remove item from wishlist
  static Future<bool> removeFromWishlist(String username, int listingId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/wishlist/remove/?user=$username&listing=$listingId'),
        headers: {'Content-Type': 'application/json'},
      );

      return response.statusCode == 204;
    } catch (e) {
      print('Error removing from wishlist: $e');
      rethrow;
    }
  }

  /// Fetch user's wishlist
  static Future<List<dynamic>> fetchWishlist(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/wishlist/user/$username/'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load wishlist: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching wishlist: $e');
      rethrow;
    }
  }
}
