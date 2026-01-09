import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ListingApi {
  // Base points to /api so endpoints become /api/listings/...
  // Use --dart-define=API_BASE="http://<your-ip>:8000/api" when running on a real device.
  static const String baseUrl = const String.fromEnvironment('API_BASE', defaultValue: 'http://10.0.2.2:8000/api');

  // Create listing with optional image paths
  static Future<bool> createListing({
    required String title,
    required String description,
    required String listingType,
    double? price,
    required String listedBy,
    List<String>? imagePaths,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/create/');

      // If images are provided, use multipart form data
      if (imagePaths != null && imagePaths.isNotEmpty) {
        final request = http.MultipartRequest('POST', uri);
        request.fields['title'] = title;
        request.fields['description'] = description;
        request.fields['listing_type'] = listingType.toLowerCase();
        if (price != null) request.fields['price'] = price.toString();
        request.fields['listed_by'] = listedBy;

        // Add images
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
          return true;
        } else {
          print('Create listing failed: ${response.statusCode} $responseBody');
          return false;
        }
      } else {
        // No images, use JSON
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
          return true;
        } else {
          print('Create listing failed: ${response.statusCode} ${response.body}');
          return false;
        }
      }
    } catch (e) {
      // avoid crashing the app on network errors — return false so caller can handle UX
      print('Create listing failed: $e');
      return false;
    }
  }

  static Future<List<dynamic>> fetchPendingListings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/pending/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load pending listings');
    }
  }

  // Approve or reject via dedicated endpoints
  static Future<bool> updateListingStatus(int id, String action) async {
    final endpoint = (action == 'approve') ? 'approve' : 'reject';
    final response = await http.patch(
      Uri.parse('$baseUrl/listings/$id/$endpoint/'),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<List<dynamic>> fetchApprovedListings() async {
    final response = await http.get(
      Uri.parse('$baseUrl/listings/approved/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load approved listings');
    }
  }

  static Future<Map<String, dynamic>> fetchAdminStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/admin/stats/'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load admin stats');
    }
  }

  static Future<List<dynamic>> fetchMyListings({String? listedBy}) async {
    final uri = listedBy != null
        ? Uri.parse('$baseUrl/listings/my/?listed_by=$listedBy')
        : Uri.parse('$baseUrl/listings/my/');

    final response = await http.get(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Failed to load my listings');
    }
  }
}
