import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/rwanda_places.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? selectedLocation;
  String? selectedPlaceName;

  @override
  void initState() {
    super.initState();
    _initializeMarkers();
  }

  void _initializeMarkers() {
    Set<Marker> newMarkers = {};

    for (int i = 0; i < rwandaPlaces.length; i++) {
      final place = rwandaPlaces[i];
      newMarkers.add(
        Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.lat, place.lng),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: place.category,
            onTap: () {
              setState(() {
                selectedLocation = LatLng(place.lat, place.lng);
                selectedPlaceName = place.name;
              });
            },
          ),
          onTap: () {
            setState(() {
              selectedLocation = LatLng(place.lat, place.lng);
              selectedPlaceName = place.name;
            });
          },
        ),
      );
    }

    setState(() {
      markers = newMarkers;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _launchGoogleMaps(double lat, double lng) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kigali Map"),
        backgroundColor: const Color(0xFF0D1B2A),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(-1.9441, 30.0619),
              zoom: 13,
            ),
            markers: markers,
            myLocationEnabled: false,
            tiltGesturesEnabled: true,
            scrollGesturesEnabled: true,
            zoomGesturesEnabled: true,
            rotateGesturesEnabled: true,
          ),
          // Bottom panel showing selected place info
          if (selectedPlaceName != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
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
                                  selectedPlaceName!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ..._getPlaceCategory(),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              setState(() {
                                selectedPlaceName = null;
                                selectedLocation = null;
                              });
                            },
                          ),
                        ],
                      ),
                      // Show matching place details
                      const SizedBox(height: 8),
                      ..._getPlaceDetails(),
                      const SizedBox(height: 12),
                      // Action buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (selectedLocation != null) {
                                  _launchGoogleMaps(
                                    selectedLocation!.latitude,
                                    selectedLocation!.longitude,
                                  );
                                }
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text("Directions"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D1B2A),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Added to bookmarks!"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.bookmark),
                              label: const Text("Bookmark"),
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
              ),
            ),
        ],
      ),
    );
  }

  List<Widget> _getPlaceCategory() {
    if (selectedPlaceName == null) return [];

    try {
      final place = rwandaPlaces.firstWhere((p) => p.name == selectedPlaceName);
      return [
        Text(
          place.category,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.star, color: Color(0xFFFFB81C), size: 14),
            const SizedBox(width: 4),
            Text(
              "${place.rating} (${place.reviewCount} reviews)",
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  List<Widget> _getPlaceDetails() {
    if (selectedPlaceName == null) return [];

    try {
      final place = rwandaPlaces.firstWhere((p) => p.name == selectedPlaceName);

      return [
        Text(
          place.description,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.location_on, color: const Color(0xFF0D1B2A), size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                place.address,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.phone, color: Colors.green, size: 16),
            const SizedBox(width: 6),
            Text(
              place.phone,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ];
    } catch (e) {
      return [];
    }
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
}
