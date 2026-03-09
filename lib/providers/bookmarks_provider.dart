import 'package:flutter/material.dart';
import '../models/listing.dart';

class BookmarkProvider extends ChangeNotifier {
  final List<Listing> _bookmarks = [];

  List<Listing> get bookmarks => List.unmodifiable(_bookmarks);

  bool isBookmarked(String id) => _bookmarks.any((l) => l.id == id);

  Future<void> toggle(Listing listing) async {
    if (isBookmarked(listing.id)) {
      _bookmarks.removeWhere((l) => l.id == listing.id);
    } else {
      _bookmarks.add(listing);
    }
    notifyListeners();
  }

  void add(Listing listing) {
    if (!isBookmarked(listing.id)) {
      _bookmarks.add(listing);
      notifyListeners();
    }
  }

  void remove(String id) {
    _bookmarks.removeWhere((l) => l.id == id);
    notifyListeners();
  }
}
