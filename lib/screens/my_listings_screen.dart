import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/listing.dart';
import '../services/firestore_service.dart';

class MyListingsScreen extends StatefulWidget {
  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("My Listings"), elevation: 0),
      body: userId.isEmpty
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
    );
  }

  void _showCreateListingDialog() {
    showDialog(
      context: context,
      builder: (context) => _ListingDialog(
        onSave: (listing) {
          _firestoreService.addListing(listing);
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
          _firestoreService.updateListing(listing.id, updatedListing);
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
              _firestoreService.deleteListing(listingId);
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

  @override
  void initState() {
    super.initState();
    final listing = widget.initialListing;

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
  }

  @override
  void dispose() {
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.initialListing == null
                    ? "Create New Listing"
                    : "Edit Listing",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
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
              TextField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Description",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
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
                      onPressed: _saveListing,
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
    );

    widget.onSave(listing);
  }
}
