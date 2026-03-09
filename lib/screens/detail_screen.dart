import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
<<<<<<< HEAD
import '../models/place.dart';
=======
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/place.dart';
import '../providers/bookmarks_provider.dart';
>>>>>>> e18d788 (addition of files)

class DetailScreen extends StatelessWidget {
  final Place place;

  const DetailScreen({super.key, required this.place});

<<<<<<< HEAD
  Future<void> _launchGoogleMaps(double lat, double lng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw 'Could not launch $googleMapsUrl';
=======
  Future<void> _launchMap(double lat, double lng) async {
    final url =
        'https://www.openstreetmap.org/?mlat=$lat&mlon=$lng#map=18/$lat/$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
>>>>>>> e18d788 (addition of files)
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(place.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Category and Rating
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        place.category,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Color(0xFFFFB81C),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            place.rating.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${place.reviewCount} reviews",
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    place.description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Location Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Location & Contact",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.location_on, color: Colors.red),
                    title: Text(
                      place.address,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      "Lat: ${place.lat.toStringAsFixed(4)}, Lng: ${place.lng.toStringAsFixed(4)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.phone, color: Colors.green),
                    title: Text(
                      place.phone,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () => _launchPhone(place.phone),
                    trailing: const Icon(Icons.open_in_new, size: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
<<<<<<< HEAD
                    onPressed: () => _launchGoogleMaps(place.lat, place.lng),
=======
                    onPressed: () => _launchMap(place.lat, place.lng),
>>>>>>> e18d788 (addition of files)
                    icon: const Icon(Icons.directions),
                    label: const Text("Get Directions"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
<<<<<<< HEAD
                    onPressed: () {
=======
                    onPressed: () async {
                      final userId =
                          FirebaseAuth.instance.currentUser?.uid ?? '';
                      if (userId.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please login to bookmark'),
                          ),
                        );
                        return;
                      }
                      await context.read<BookmarksProvider>().addBookmark(
                        userId,
                        place.name,
                      );
>>>>>>> e18d788 (addition of files)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Added to bookmarks!"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.bookmark_outline),
                    label: const Text("Bookmark"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
