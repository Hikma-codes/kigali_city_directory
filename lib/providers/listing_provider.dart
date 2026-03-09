import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/firestore_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<Listing>> get listings => _firestoreService.getListings();

  Stream<List<Listing>> getUserListings(String userId) =>
      _firestoreService.getUserListings(userId);

  Future<String?> addListing(Listing listing) async {
    try {
      final id = await _firestoreService.addListing(listing);
      notifyListeners();
      return id;
    } catch (e) {
      debugPrint('Error adding listing: $e');
      return null;
    }
  }

  Future<void> updateListing(String id, Listing listing) async {
    try {
      await _firestoreService.updateListing(id, listing);
      notifyListeners();
    } catch (e) {
      debugPrint('Error updating listing: $e');
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      await _firestoreService.deleteListing(id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting listing: $e');
    }
  }

  Stream<List<Listing>> searchListings(String query, String category) =>
      _firestoreService.searchListings(query, category);
}
