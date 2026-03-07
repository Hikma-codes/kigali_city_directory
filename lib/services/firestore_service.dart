import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CREATE - Add listing
  Future<String> addListing(Listing listing) async {
    try {
      final docRef = await _db.collection('listings').add({
        'name': listing.name,
        'description': listing.description,
        'category': listing.category,
        'address': listing.address,
        'phone': listing.phone,
        'latitude': listing.latitude,
        'longitude': listing.longitude,
        'createdBy': listing.createdBy,
        'timestamp': FieldValue.serverTimestamp(),
        'rating': listing.rating,
        'reviewCount': listing.reviewCount,
      });
      return docRef.id;
    } catch (e) {
      print('Error adding listing: $e');
      rethrow;
    }
  }

  // READ - Get all listings
  Stream<List<Listing>> getListings() {
    return _db
        .collection('listings')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Listing.fromMap(doc.data(), doc.id))
              .toList();
        })
        .handleError((error) {
          print('Error getting listings: $error');
          return [];
        });
  }

  // READ - Get user's listings
  Stream<List<Listing>> getUserListings(String userId) {
    return _db
        .collection('listings')
        .where('createdBy', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Listing.fromMap(doc.data(), doc.id))
              .toList();
        })
        .handleError((error) {
          print('Error getting user listings: $error');
          return [];
        });
  }

  // UPDATE - Update listing
  Future<void> updateListing(String id, Listing listing) async {
    try {
      await _db.collection('listings').doc(id).update({
        'name': listing.name,
        'description': listing.description,
        'category': listing.category,
        'address': listing.address,
        'phone': listing.phone,
        'latitude': listing.latitude,
        'longitude': listing.longitude,
      });
    } catch (e) {
      print('Error updating listing: $e');
      rethrow;
    }
  }

  // DELETE - Delete listing
  Future<void> deleteListing(String id) async {
    try {
      await _db.collection('listings').doc(id).delete();
    } catch (e) {
      print('Error deleting listing: $e');
      rethrow;
    }
  }

  // Get single listing
  Future<Listing?> getListing(String id) async {
    try {
      final doc = await _db.collection('listings').doc(id).get();
      if (doc.exists) {
        return Listing.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting single listing: $e');
      return null;
    }
  }

  // Search listings by name and category
  Stream<List<Listing>> searchListings(String query, String category) {
    return _db
        .collection('listings')
        .snapshots()
        .map((snapshot) {
          var listings = snapshot.docs
              .map((doc) => Listing.fromMap(doc.data(), doc.id))
              .toList();

          // Filter by category
          if (category != 'All') {
            listings = listings.where((l) => l.category == category).toList();
          }

          // Filter by search query
          if (query.isNotEmpty) {
            listings = listings
                .where(
                  (l) => l.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
          }

          return listings;
        })
        .handleError((error) {
          print('Error searching listings: $error');
          return [];
        });
  }
}
