import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:firebase_auth/firebase_auth.dart';
import '../models/listing.dart';
import '../services/firestore_service.dart';
=======
import 'package:provider/provider.dart';
import '../models/listing.dart';
import '../models/place.dart';
import '../data/rwanda_places.dart';
import '../providers/exports.dart';
import 'listing_detail_screen.dart';
>>>>>>> e18d788 (addition of files)

class MyListingsScreen extends StatefulWidget {
  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
<<<<<<< HEAD
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("My Listings"), elevation: 0),
      body: userId.isEmpty
=======
  String searchQuery = '';
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Hospital',
    'Police Station',
    'Library',
    'Restaurant',
    'Café',
    'Park',
    'Tourist Attraction',
    'Pharmacy',
    'Game Center',
    'Shopping Mall',
  ];

  List<Listing> _filterListings(List<Listing> listings) {
    var filtered = listings;

    // Filter by category
    if (selectedCategory != 'All') {
      filtered = filtered
          .where((listing) => listing.category == selectedCategory)
          .toList();
    }

    // Filter by search query
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((listing) =>
              listing.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
              listing.description
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase()))
          .toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final listingProvider = context.read<ListingProvider>();
    final userId = authProvider.userId;

    return Scaffold(
      appBar: AppBar(title: const Text("My Listings"), elevation: 0),
      body: !authProvider.isLoggedIn
>>>>>>> e18d788 (addition of files)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.login, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text("Please log in to manage listings"),
                ],
              ),
            )
<<<<<<< HEAD
          : StreamBuilder<List<Listing>>(
              stream: _firestoreService.getUserListings(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final listings = snapshot.data ?? [];

                if (listings.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inbox, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        const Text("No listings yet"),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => _showCreateListingDialog(),
                          icon: const Icon(Icons.add),
                          label: const Text("Create Listing"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D1B2A),
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: () => _showCreateListingDialog(),
                        icon: const Icon(Icons.add),
                        label: const Text("New Listing"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D1B2A),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listings.length,
                        itemBuilder: (context, index) {
                          final listing = listings[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: const Color(0xFF0D1B2A),
                                child: Text(
                                  listing.name[0].toUpperCase(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(
                                listing.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                listing.category,
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text("Edit"),
                                    onTap: () =>
                                        _showEditListingDialog(listing),
                                  ),
                                  PopupMenuItem(
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () =>
                                        _showDeleteConfirmation(listing.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
=======
          : userId.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Loading user data..."),
                    ],
                  ),
                )
              : StreamBuilder<List<Listing>>(
                  stream: listingProvider.getUserListings(userId),
                  builder: (context, snapshot) {
                    // Loading state
                    if (snapshot.connectionState == ConnectionState.waiting &&
                        snapshot.data == null) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text("Loading listings..."),
                          ],
                        ),
                      );
                    }

                    // Error state
                    if (snapshot.hasError && snapshot.data == null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error,
                                size: 64, color: Colors.red),
                            const SizedBox(height: 16),
                            Text('Error: ${snapshot.error}'),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {});
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      );
                    }

                    final listings = snapshot.data ?? [];
                    final filteredListings = _filterListings(listings);

                    // Empty state
                    if (listings.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.inbox,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text("No listings yet"),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: () => _showCreateListingDialog(),
                              icon: const Icon(Icons.add),
                              label: const Text("Create Listing"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D1B2A),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Column(
                      children: [
                        // New Listing Button
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton.icon(
                            onPressed: () => _showCreateListingDialog(),
                            icon: const Icon(Icons.add),
                            label: const Text("New Listing"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0D1B2A),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),

                        // Category Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              children: categories
                                  .map(
                                    (category) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: FilterChip(
                                        label: Text(category),
                                        selected: selectedCategory == category,
                                        onSelected: (isSelected) {
                                          setState(() {
                                            selectedCategory = category;
                                          });
                                        },
                                        selectedColor: const Color(0xFF0D1B2A),
                                        labelStyle: TextStyle(
                                          color: selectedCategory == category
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),

                        // Search Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                              hintText: "Search listings",
                              prefixIcon: const Icon(Icons.search),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),

                        // Filtered Listings or No Results
                        if (filteredListings.isEmpty)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search_off,
                                      size: 64, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  const Text("No listings found"),
                                ],
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredListings.length,
                              itemBuilder: (context, index) {
                                final listing = filteredListings[index];
                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ListingDetailScreen(
                                                  listing: listing),
                                        ),
                                      ).then((result) {
                                        if (result == 'edit') {
                                          _showEditListingDialog(listing);
                                        }
                                      });
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFF0D1B2A),
                                        child: Text(
                                          listing.name[0].toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      title: Text(
                                        listing.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listing.category,
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            listing.address,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        itemBuilder: (context) => [
                                          PopupMenuItem(
                                            child: const Text("Edit"),
                                            onTap: () =>
                                                _showEditListingDialog(listing),
                                          ),
                                          PopupMenuItem(
                                            child: const Text(
                                              "Delete",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                            onTap: () =>
                                                _showDeleteConfirmation(
                                                    listing.id),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
>>>>>>> e18d788 (addition of files)
    );
  }

  void _showCreateListingDialog() {
    showDialog(
      context: context,
      builder: (context) => _ListingDialog(
        onSave: (listing) {
<<<<<<< HEAD
          _firestoreService.addListing(listing);
=======
          context.read<ListingProvider>().addListing(listing);
>>>>>>> e18d788 (addition of files)
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Listing created successfully!")),
          );
        },
      ),
    );
  }

  void _showEditListingDialog(Listing listing) {
    showDialog(
      context: context,
      builder: (context) => _ListingDialog(
        initialListing: listing,
        onSave: (updatedListing) {
<<<<<<< HEAD
          _firestoreService.updateListing(listing.id, updatedListing);
=======
          context
              .read<ListingProvider>()
              .updateListing(listing.id, updatedListing);
>>>>>>> e18d788 (addition of files)
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Listing updated successfully!")),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(String listingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Listing"),
        content: const Text("Are you sure you want to delete this listing?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
<<<<<<< HEAD
              _firestoreService.deleteListing(listingId);
=======
              context.read<ListingProvider>().deleteListing(listingId);
>>>>>>> e18d788 (addition of files)
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Listing deleted")));
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

// Dialog form for creating/editing listings
class _ListingDialog extends StatefulWidget {
  final Listing? initialListing;
  final Function(Listing) onSave;

  const _ListingDialog({this.initialListing, required this.onSave});

  @override
  State<_ListingDialog> createState() => _ListingDialogState();
}

class _ListingDialogState extends State<_ListingDialog> {
<<<<<<< HEAD
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _latController;
  late TextEditingController _lngController;

  String _selectedCategory = "Hospital";
  final List<String> _categories = [
    "Hospital",
    "Police Station",
    "Library",
    "Restaurant",
    "Café",
    "Park",
    "Tourist Attraction",
    "Pharmacy",
    "Game Center",
    "Shopping Mall",
  ];
=======
  // For creating new listing: place picker
  Place? _selectedPlace;
  String _placeSearchQuery = '';

  // For both create and edit
  late TextEditingController _phoneController;
  late TextEditingController _descriptionController;
>>>>>>> e18d788 (addition of files)

  @override
  void initState() {
    super.initState();
    final listing = widget.initialListing;

<<<<<<< HEAD
    _nameController = TextEditingController(text: listing?.name ?? '');
    _descriptionController = TextEditingController(
      text: listing?.description ?? '',
    );
    _addressController = TextEditingController(text: listing?.address ?? '');
    _phoneController = TextEditingController(text: listing?.phone ?? '');
    _latController = TextEditingController(
      text: listing?.latitude.toString() ?? '',
    );
    _lngController = TextEditingController(
      text: listing?.longitude.toString() ?? '',
    );
    _selectedCategory = listing?.category ?? "Hospital";
=======
    _phoneController = TextEditingController(text: listing?.phone ?? '');
    _descriptionController = TextEditingController(
      text: listing?.description ?? '',
    );
>>>>>>> e18d788 (addition of files)
  }

  @override
  void dispose() {
<<<<<<< HEAD
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _latController.dispose();
    _lngController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
=======
    _phoneController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Filter places by search query
  List<Place> _getFilteredPlaces() {
    if (_placeSearchQuery.isEmpty) {
      return rwandaPlaces;
    }
    return rwandaPlaces
        .where((place) =>
            place.name
                .toLowerCase()
                .contains(_placeSearchQuery.toLowerCase()) ||
            place.category
                .toLowerCase()
                .contains(_placeSearchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialListing != null;

    // If editing: show simplified form
    if (isEditing) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Edit Listing",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 16),

                // Display place info (read-only)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.initialListing!.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.initialListing!.category,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.initialListing!.address,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Description
                TextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Description",
                    hintText: "Tell people about this place...",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Phone
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone Number",
                    hintText: "+250791234567",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _saveEditedListing,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D1B2A),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Save"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // If creating: show place picker first
    if (_selectedPlace == null) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Select a Place to List",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Choose from existing locations in Kigali",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 16),

                // Search bar
                TextField(
                  onChanged: (value) {
                    setState(() => _placeSearchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: "Search places...",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Places list
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _getFilteredPlaces().length,
                    itemBuilder: (context, index) {
                      final place = _getFilteredPlaces()[index];
                      return ListTile(
                        onTap: () {
                          setState(() => _selectedPlace = place);
                        },
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFF0D1B2A),
                          child: Text(
                            place.name[0],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(place.name),
                        subtitle: Text(
                          place.category,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // After place selected: show form for description + phone
>>>>>>> e18d788 (addition of files)
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
<<<<<<< HEAD
              Text(
                widget.initialListing == null
                    ? "Create New Listing"
                    : "Edit Listing",
                style: const TextStyle(
=======
              const Text(
                "Create Listing",
                style: TextStyle(
>>>>>>> e18d788 (addition of files)
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
<<<<<<< HEAD
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: "Place/Service Name",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value ?? "Hospital");
                },
                decoration: InputDecoration(
                  hintText: "Category",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  hintText: "Address",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  hintText: "Phone Number",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
=======

              // Place info (auto-filled, read-only)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  border: Border.all(color: Colors.blue[200]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedPlace!.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedPlace!.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue[600],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedPlace!.address,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() => _selectedPlace = null);
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Change"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Description
>>>>>>> e18d788 (addition of files)
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
<<<<<<< HEAD
                  hintText: "Description",
=======
                  labelText: "Description",
                  hintText: "Tell people about this place...",
>>>>>>> e18d788 (addition of files)
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
<<<<<<< HEAD
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _latController,
                      decoration: InputDecoration(
                        hintText: "Latitude",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _lngController,
                      decoration: InputDecoration(
                        hintText: "Longitude",
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
=======

              // Phone
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  hintText: "+250791234567",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
>>>>>>> e18d788 (addition of files)
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
<<<<<<< HEAD
                      onPressed: _saveListing,
=======
                      onPressed: _saveNewListing,
>>>>>>> e18d788 (addition of files)
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D1B2A),
                        foregroundColor: Colors.white,
                      ),
<<<<<<< HEAD
                      child: const Text("Save"),
=======
                      child: const Text("Create"),
>>>>>>> e18d788 (addition of files)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

<<<<<<< HEAD
  void _saveListing() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _latController.text.isEmpty ||
        _lngController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final listing = Listing(
      id: widget.initialListing?.id ?? '',
      name: _nameController.text,
      description: _descriptionController.text,
      category: _selectedCategory,
      address: _addressController.text,
      phone: _phoneController.text,
      latitude: double.tryParse(_latController.text) ?? 0.0,
      longitude: double.tryParse(_lngController.text) ?? 0.0,
      createdBy:
          widget.initialListing?.createdBy ??
          FirebaseAuth.instance.currentUser?.uid ??
          '',
      timestamp: widget.initialListing?.timestamp ?? DateTime.now(),
=======
  void _saveNewListing() {
    if (_selectedPlace == null ||
        _phoneController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final listing = Listing(
      id: '',
      name: _selectedPlace!.name,
      description: _descriptionController.text,
      category: _selectedPlace!.category,
      address: _selectedPlace!.address,
      phone: _phoneController.text,
      latitude: _selectedPlace!.lat,
      longitude: _selectedPlace!.lng,
      createdBy: authProvider.userId,
      timestamp: DateTime.now(),
    );

    widget.onSave(listing);
  }

  void _saveEditedListing() {
    if (_phoneController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final listing = widget.initialListing!.copyWith(
      description: _descriptionController.text,
      phone: _phoneController.text,
>>>>>>> e18d788 (addition of files)
    );

    widget.onSave(listing);
  }
}
