import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../providers/bookmarks_provider.dart';
import '../data/rwanda_places.dart';
import '../models/place.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Please log in to view bookmarks',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return StreamBuilder<List<String>>(
      stream: context.read<BookmarksProvider>().getBookmarks(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: \\${snapshot.error}'));
        }
        final bookmarks = snapshot.data ?? [];
        if (bookmarks.isEmpty) {
          return const Center(child: Text('No bookmarks yet'));
        }
        // map names back to Place objects if available
        final places = rwandaPlaces
            .where((p) => bookmarks.contains(p.name))
            .toList(growable: false);

        return ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            final place = places[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF0D1B2A),
                  child: Text(
                    place.name[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(place.name),
                subtitle: Text(place.category),
                onTap: () {
                  // show detail bottom sheet similar to DirectoryScreen
                  showModalBottomSheet(
                    context: context,
                    builder: (ctx) =>
                        _buildPlaceDetails(context, place, userId),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPlaceDetails(BuildContext context, Place place, String userId) {
    final provider = context.read<BookmarksProvider>();
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        place.category,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.star, color: Color(0xFFFFB81C)),
                const SizedBox(width: 8),
                Text(
                  "${place.rating} (${place.reviewCount} reviews)",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              place.description,
              style: const TextStyle(color: Colors.black87, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    place.address,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.phone, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Text(
                  place.phone,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // use shared map launcher maybe
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text("Get Directions"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await provider.removeBookmark(userId, place.name);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Removed bookmark")),
                      );
                    },
                    icon: const Icon(Icons.bookmark_remove),
                    label: const Text("Remove"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
