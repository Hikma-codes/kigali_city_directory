class Place {
  final String name;
  final String category;
  final String description;
  final double lat;
  final double lng;
  final double rating;
  final String phone;
  final String address;
  final int reviewCount;

  Place({
    required this.name,
    required this.category,
    required this.description,
    required this.lat,
    required this.lng,
    required this.rating,
    required this.phone,
    required this.address,
    this.reviewCount = 0,
  });
}
