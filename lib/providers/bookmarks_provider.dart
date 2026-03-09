import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class BookmarksProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  Stream<List<String>> getBookmarks(String userId) {
    return _firestoreService.getBookmarks(userId);
  }

  Future<void> addBookmark(String userId, String placeName) async {
    await _firestoreService.addBookmark(userId, placeName);
  }

  Future<void> removeBookmark(String userId, String placeName) async {
    await _firestoreService.removeBookmark(userId, placeName);
  }
}
