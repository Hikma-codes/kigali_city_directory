import 'package:cloud_firestore/cloud_firestore.dart';

class Listing {
  final String id;
  final String name;
  final String description;
  final String category;
  final String address;
  final String phone;
  final double latitude;
  final double longitude;
  final String createdBy; // User UID
  final DateTime timestamp;
  final double rating;
  final int reviewCount;

  Listing({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.address,
    required this.phone,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
    this.rating = 0.0,
    this.reviewCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'address': address,
      'phone': phone,
      'latitude': latitude,
      'longitude': longitude,
      'createdBy': createdBy,
      'timestamp': timestamp,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory Listing.fromMap(Map<String, dynamic> map, String docId) {
    return Listing(
      id: docId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      latitude: (map['latitude'] ?? 0.0).toDouble(),
      longitude: (map['longitude'] ?? 0.0).toDouble(),
      createdBy: map['createdBy'] ?? '',
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  Listing copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    String? address,
    String? phone,
    double? latitude,
    double? longitude,
    String? createdBy,
    DateTime? timestamp,
    double? rating,
    int? reviewCount,
  }) {
    return Listing(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      createdBy: createdBy ?? this.createdBy,
      timestamp: timestamp ?? this.timestamp,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}
