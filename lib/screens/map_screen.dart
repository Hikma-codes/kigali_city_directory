import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/rwanda_places.dart';
import '../models/listing.dart';
import '../providers/bookmarks_provider.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String? _selectedPlaceName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kigali Map"),
        backgroundColor: const Color(0xFF0D1B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // ── Map ───────────────────────────────────────────────────────────
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(-1.9441, 30.0619),
              initialZoom: 13,
              onTap: (_, __) => setState(() => _selectedPlaceName = null),
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
                userAgentPackageName: 'com.example.kigali_city_directory',
              ),
              MarkerLayer(
                markers: rwandaPlaces.map((place) {
                  final isSelected = place.name == _selectedPlaceName;
                  return Marker(
                    point: LatLng(place.lat, place.lng),
                    width: 48,
                    height: 48,
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedPlaceName = place.name),
                      child: AnimatedScale(
                        scale: isSelected ? 1.3 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.location_on,
                          color: isSelected
                              ? const Color(0xFF0D1B2A)
                              : Colors.red,
                          size: 36,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // ── Place info panel ──────────────────────────────────────────────
          if (_selectedPlaceName != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _PlaceInfoPanel(
                placeName: _selectedPlaceName!,
                onClose: () => setState(() => _selectedPlaceName = null),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Place info bottom panel ──────────────────────────────────────────────────

class _PlaceInfoPanel extends StatelessWidget {
  final String placeName;
  final VoidCallback onClose;

  const _PlaceInfoPanel(
      {required this.placeName, required this.onClose});

  @override
  Widget build(BuildContext context) {
    // Find the place from local data
    final place =
        rwandaPlaces.firstWhere((p) => p.name == placeName);

    // Convert to a Listing so BookmarkProvider can consume it
    final listing = Listing(
      id: place.name, // use name as stable id for local data
      name: place.name,
      description: '',
      category: place.category,
      address: place.address,
      phone: place.phone,
      latitude: place.lat,
      longitude: place.lng,
      createdBy: '',
      timestamp: DateTime.now(),
    );

    return Consumer<BookmarkProvider>(
      builder: (context, bookmarkProvider, _) {
        final isBookmarked = bookmarkProvider.isBookmarked(listing.id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Name + close
              Row(
                children: [
                  Expanded(
                    child: Text(
                      place.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ],
              ),

              // Category badge
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1B2A).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  place.category,
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF0D1B2A)),
                ),
              ),

              const SizedBox(height: 10),

              // Address
              if (place.address.isNotEmpty)
                _InfoRow(
                    icon: Icons.location_on, text: place.address),

              // Phone
              if (place.phone.isNotEmpty)
                _InfoRow(icon: Icons.phone, text: place.phone),

              const SizedBox(height: 14),

              // Action buttons
              Row(
                children: [
                  // Directions
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.directions, size: 18),
                      label: const Text("Directions"),
                      onPressed: () {
                        final url =
                            'https://www.google.com/maps/search/?api=1&query=${place.lat},${place.lng}';
                        launchUrl(Uri.parse(url),
                            mode: LaunchMode.externalApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D1B2A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Bookmark toggle
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(
                        isBookmarked
                            ? Icons.bookmark
                            : Icons.bookmark_border,
                        size: 18,
                      ),
                      label: Text(
                          isBookmarked ? "Bookmarked" : "Bookmark"),
                      onPressed: () async {
                        await bookmarkProvider.toggle(listing);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isBookmarked
                                  ? "${place.name} removed from bookmarks"
                                  : "${place.name} added to bookmarks"),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isBookmarked
                            ? const Color(0xFF0D1B2A)
                            : Colors.grey.shade200,
                        foregroundColor: isBookmarked
                            ? Colors.white
                            : Colors.black87,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}