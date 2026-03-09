import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/rwanda_places.dart';
=======
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/rwanda_places.dart';
import '../providers/bookmarks_provider.dart';
>>>>>>> e18d788 (addition of files)

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
<<<<<<< HEAD
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? selectedLocation;
  String? selectedPlaceName;
=======
  List<Marker> markers = [];
  LatLng? selectedLocation;
  String? selectedPlaceName;
  late MapController mapController;
  LatLng userLocation =
      const LatLng(-1.9441, 30.0619); 
>>>>>>> e18d788 (addition of files)

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
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
=======
    mapController = MapController();
    _initializeMarkers();

    // Handle navigation arguments from listing detail screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        final latitude = args['latitude'] as double?;
        final longitude = args['longitude'] as double?;
        final placeName = args['placeName'] as String?;

        if (latitude != null && longitude != null) {
          setState(() {
            selectedLocation = LatLng(latitude, longitude);
            selectedPlaceName = placeName ?? 'Location';
          });
          _centerOnLocation(latitude, longitude);
        }
      }
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _initializeMarkers() {
    markers = rwandaPlaces.map((place) {
      return Marker(
        point: LatLng(place.lat, place.lng),
        width: 40,
        height: 40,
        child: GestureDetector(
>>>>>>> e18d788 (addition of files)
          onTap: () {
            setState(() {
              selectedLocation = LatLng(place.lat, place.lng);
              selectedPlaceName = place.name;
            });
          },
<<<<<<< HEAD
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
=======
          child: const Icon(
            Icons.location_on,
            color: Colors.red,
            size: 30,
          ),
        ),
      );
    }).toList();
  }

  void _centerOnLocation(double lat, double lng) {
    mapController.move(LatLng(lat, lng), 16.0);
>>>>>>> e18d788 (addition of files)
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
<<<<<<< HEAD
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
=======
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(-1.9441, 30.0619),
              initialZoom: 13,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              ),
              MarkerLayer(markers: markers),
              // Navigation polyline (blue line from user to selected location)
              if (selectedLocation != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [userLocation, selectedLocation!],
                      color: Colors.blue,
                      strokeWidth: 4,
                      isDotted: false,
                    ),
                  ],
                ),
            ],
>>>>>>> e18d788 (addition of files)
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
<<<<<<< HEAD
                                  _launchGoogleMaps(
                                    selectedLocation!.latitude,
                                    selectedLocation!.longitude,
                                  );
                                }
                              },
                              icon: const Icon(Icons.directions),
                              label: const Text("Directions"),
=======
                                  _centerOnLocation(
                                    selectedLocation!.latitude,
                                    selectedLocation!.longitude,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Map centered on location"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.navigation),
                              label: const Text("Navigate"),
>>>>>>> e18d788 (addition of files)
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D1B2A),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
<<<<<<< HEAD
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
=======
                            child: StreamBuilder<List<String>>(
                              stream: context
                                  .read<BookmarksProvider>()
                                  .getBookmarks(
                                    FirebaseAuth.instance.currentUser?.uid ??
                                        '',
                                  ),
                              builder: (context, snap) {
                                final bookmarked = selectedPlaceName != null &&
                                    (snap.data?.contains(selectedPlaceName) ??
                                        false);
                                return ElevatedButton.icon(
                                  onPressed: () async {
                                    final userId = FirebaseAuth
                                            .instance.currentUser?.uid ??
                                        '';
                                    if (userId.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Please login to bookmark',
                                          ),
                                        ),
                                      );
                                      return;
                                    }
                                    if (bookmarked &&
                                        selectedPlaceName != null) {
                                      await context
                                          .read<BookmarksProvider>()
                                          .removeBookmark(
                                            userId,
                                            selectedPlaceName!,
                                          );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Removed bookmark"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    } else if (selectedPlaceName != null) {
                                      await context
                                          .read<BookmarksProvider>()
                                          .addBookmark(
                                            userId,
                                            selectedPlaceName!,
                                          );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Added to bookmarks!"),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  icon: Icon(
                                    bookmarked
                                        ? Icons.bookmark
                                        : Icons.bookmark_outline,
                                  ),
                                  label: Text(
                                    bookmarked ? "Bookmarked" : "Bookmark",
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black,
                                  ),
                                );
                              },
>>>>>>> e18d788 (addition of files)
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
<<<<<<< HEAD

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }
=======
>>>>>>> e18d788 (addition of files)
}
