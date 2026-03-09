import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/listing.dart';
import '../providers/bookmarks_provider.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<BookmarkProvider>(
        builder: (context, provider, _) {
          final bookmarks = provider.bookmarks;

          if (bookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.bookmark_border, size: 72, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "No bookmarks yet",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap the bookmark icon on any place\nto save it here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final listing = bookmarks[index];
              return _BookmarkCard(listing: listing);
            },
          );
        },
      ),
    );
  }
}

class _BookmarkCard extends StatelessWidget {
  final Listing listing;
  const _BookmarkCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BookmarkProvider>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header row ──────────────────────────────────────────────────
          ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF0D1B2A),
              child: Text(
                listing.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              listing.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(listing.category),
            trailing: IconButton(
              tooltip: "Remove bookmark",
              icon: const Icon(Icons.bookmark, color: Color(0xFF0D1B2A)),
              onPressed: () {
                provider.remove(listing.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${listing.name} removed from bookmarks"),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () => provider.toggle(listing),
                    ),
                  ),
                );
              },
            ),
          ),

          // ── Details ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (listing.address.isNotEmpty)
                  _DetailRow(icon: Icons.location_on, text: listing.address),
                if (listing.phone.isNotEmpty)
                  _DetailRow(icon: Icons.phone, text: listing.phone),
                if (listing.description.isNotEmpty)
                  _DetailRow(
                    icon: Icons.info_outline,
                    text: listing.description,
                  ),
                if (listing.rating > 0)
                  _DetailRow(
                    icon: Icons.star,
                    text:
                        '${listing.rating.toStringAsFixed(1)} · ${listing.reviewCount} reviews',
                    iconColor: Colors.amber,
                  ),
              ],
            ),
          ),

          // ── Actions ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
            child: Row(
              children: [
                // Directions button
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.directions, size: 18),
                    label: const Text("Directions"),
                    onPressed: listing.latitude != 0.0
                        ? () => _openDirections(listing)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Call button
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.call, size: 18),
                    label: const Text("Call"),
                    onPressed: listing.phone.isNotEmpty
                        ? () => _callPhone(listing.phone)
                        : null,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openDirections(Listing listing) {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${listing.latitude},${listing.longitude}';
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  void _callPhone(String phone) {
    final uri = Uri(scheme: 'tel', path: phone);
    launchUrl(uri);
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const _DetailRow({required this.icon, required this.text, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: iconColor ?? Colors.grey),
          const SizedBox(width: 6),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
