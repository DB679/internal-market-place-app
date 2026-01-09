import 'package:flutter/material.dart';
import 'listing_api.dart';

class ListingProvider extends ChangeNotifier {
  List<dynamic> _approvedListings = [];
  List<dynamic> _pendingListings = [];
  List<dynamic> _myListings = [];
  
  bool _loadingApproved = false;
  bool _loadingPending = false;
  bool _loadingMy = false;

  // Getters
  List<dynamic> get approvedListings => _approvedListings;
  List<dynamic> get pendingListings => _pendingListings;
  List<dynamic> get myListings => _myListings;
  
  bool get loadingApproved => _loadingApproved;
  bool get loadingPending => _loadingPending;
  bool get loadingMy => _loadingMy;

  /// Fetch all approved listings
  Future<void> fetchApproved() async {
    _loadingApproved = true;
    notifyListeners();
    
    try {
      _approvedListings = await ListingApi.fetchApprovedListings();
    } catch (e) {
      print('Error fetching approved listings: $e');
    } finally {
      _loadingApproved = false;
      notifyListeners();
    }
  }

  /// Fetch pending listings (Admin only)
  Future<void> fetchPending() async {
    _loadingPending = true;
    notifyListeners();
    
    try {
      _pendingListings = await ListingApi.fetchPendingListings();
    } catch (e) {
      print('Error fetching pending listings: $e');
    } finally {
      _loadingPending = false;
      notifyListeners();
    }
  }

  /// Fetch user's own listings
  Future<void> fetchMyListings({required String listedBy}) async {
    _loadingMy = true;
    notifyListeners();
    
    try {
      _myListings = await ListingApi.fetchMyListings(listedBy: listedBy);
    } catch (e) {
      print('Error fetching my listings: $e');
    } finally {
      _loadingMy = false;
      notifyListeners();
    }
  }

  /// Create a new listing
  Future<bool> createListing({
    required String title,
    required String description,
    required String listingType,
    double? price,
    required String listedBy,
    List<String>? imagePaths,
  }) async {
    try {
      await ListingApi.createListing(
        title: title,
        description: description,
        listingType: listingType,
        price: price,
        listedBy: listedBy,
        imagePaths: imagePaths,
      );
      
      // Refresh all data after creating a listing
      await refreshAll();
      return true;
    } catch (e) {
      print('Error creating listing: $e');
      return false;
    }
  }

  /// Approve a listing (Admin only)
  Future<bool> approveListing(int id) async {
    try {
      await ListingApi.updateListingStatus(id, 'approve');
      // Refresh all data after approval
      await refreshAll();
      return true;
    } catch (e) {
      print('Error approving listing: $e');
      return false;
    }
  }

  /// Reject a listing (Admin only)
  Future<bool> rejectListing(int id) async {
    try {
      await ListingApi.updateListingStatus(id, 'reject');
      // Refresh all data after rejection
      await refreshAll();
      return true;
    } catch (e) {
      print('Error rejecting listing: $e');
      return false;
    }
  }

  /// Central refresh logic - call this after any data mutation
  Future<void> refreshAll() async {
    await Future.wait([
      fetchApproved(),
      fetchPending(),
    ]);
    notifyListeners();
  }
}
