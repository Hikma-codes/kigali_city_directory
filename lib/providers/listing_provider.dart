import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/listing.dart';
import '../services/firestore_service.dart';

class ListingProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<Listing>> get listings {
    return _firestoreService.getListings();
  }

  Stream<List<Listing>> getUserListings(String userId) {
    return _firestoreService.getUserListings(userId);
  }

  Future<String?> addListing(Listing listing) async {
    try {
      final id = await _firestoreService.addListing(listing);
      notifyListeners();
      return id;
    } catch (e) {
      print('Error adding listing: $e');
      return null;
    }
  }

  Future<void> updateListing(String id, Listing listing) async {
    try {
      await _firestoreService.updateListing(id, listing);
      notifyListeners();
    } catch (e) {
      print('Error updating listing: $e');
    }
  }

  Future<void> deleteListing(String id) async {
    try {
      await _firestoreService.deleteListing(id);
      notifyListeners();
    } catch (e) {
      print('Error deleting listing: $e');
    }
  }

  Stream<List<Listing>> searchListings(String query, String category) {
    return _firestoreService.searchListings(query, category);
  }
}
