import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/listing.dart';

class FirestoreService {
<<<<<<< HEAD
=======
  // Singleton pattern
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

>>>>>>> e18d788 (addition of files)
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
<<<<<<< HEAD
          return snapshot.docs
              .map((doc) => Listing.fromMap(doc.data(), doc.id))
              .toList();
        })
        .handleError((error) {
          print('Error getting listings: $error');
          return [];
        });
=======
      return snapshot.docs
          .map((doc) => Listing.fromMap(doc.data(), doc.id))
          .toList();
    }).handleError((error) {
      print('Error getting listings: $error');
      return [];
    });
>>>>>>> e18d788 (addition of files)
  }

  // READ - Get user's listings
  Stream<List<Listing>> getUserListings(String userId) {
<<<<<<< HEAD
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
=======
    if (userId.isEmpty) {
      // Return empty stream if userId is empty
      return Stream.value([]);
    }

    try {
      return _db
          .collection('listings')
          .where('createdBy', isEqualTo: userId)
          .snapshots()
          .map<List<Listing>>((snapshot) {
        try {
          final listings = snapshot.docs
              .map((doc) {
                try {
                  return Listing.fromMap(doc.data(), doc.id);
                } catch (e) {
                  print('Error parsing listing ${doc.id}: $e');
                  return null;
                }
              })
              .whereType<Listing>()
              .toList();

          // Sort client-side rather than database-side to avoid composite index requirement
          listings.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          return listings;
        } catch (e) {
          print('Error processing listings: $e');
          return [];
        }
      }).handleError((error) {
        print('Error getting user listings: $error');
      }, test: (error) => true);
    } catch (e) {
      print('Error setting up user listings stream: $e');
      return Stream.value([]);
    }
>>>>>>> e18d788 (addition of files)
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
<<<<<<< HEAD
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
=======
    return _db.collection('listings').snapshots().map((snapshot) {
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
    }).handleError((error) {
      print('Error searching listings: $error');
      return [];
    });
  }

  // BOOKMARKS - store user-specific list of place names
  Stream<List<String>> getBookmarks(String userId) {
    return _db.collection('users').doc(userId).snapshots().map((doc) {
      final data = doc.data();
      if (data != null && data['bookmarks'] != null) {
        return List<String>.from(data['bookmarks']);
      }
      return <String>[];
    }).handleError((error) {
      print('Error getting bookmarks: $error');
      return <String>[];
    });
  }

  Future<void> addBookmark(String userId, String placeName) async {
    try {
      await _db.collection('users').doc(userId).set({
        'bookmarks': FieldValue.arrayUnion([placeName]),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error adding bookmark: $e');
      rethrow;
    }
  }

  Future<void> removeBookmark(String userId, String placeName) async {
    try {
      await _db.collection('users').doc(userId).update({
        'bookmarks': FieldValue.arrayRemove([placeName]),
      });
    } catch (e) {
      print('Error removing bookmark: $e');
      rethrow;
    }
  }

  // USER PROFILE - Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String email,
    required String displayName,
  }) async {
    try {
      await _db.collection('users').doc(uid).set({
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'bookmarks': [],
        'createdAt': FieldValue.serverTimestamp(),
        'notificationsEnabled': true,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error creating user profile: $e');
      rethrow;
    }
>>>>>>> e18d788 (addition of files)
  }
}
