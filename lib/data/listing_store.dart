import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../models/category.dart';
import '../models/listing.dart';
import 'sample_data.dart';

/// Keeps the listings in memory and tells the screens when they change.
/// Screens listen to it with ListenableBuilder. In Step 3 the same
/// methods will read and write Firestore instead.
class ListingStore extends ChangeNotifier {
  ListingStore._() : _listings = SampleData.listings();

  static final ListingStore instance = ListingStore._();

  final List<Listing> _listings;
  int _nextId = 100;

  AppUser get currentUser => SampleData.currentUser;

  /// Unsold listings for the Home screen, newest first,
  /// filtered by title and category.
  List<Listing> activeListings({String query = '', ListingCategory? category}) {
    final q = query.trim().toLowerCase();
    final result = _listings.where((l) {
      if (l.isSold) return false;
      if (category != null && l.category != category) return false;
      if (q.isNotEmpty && !l.title.toLowerCase().contains(q)) return false;
      return true;
    }).toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  List<Listing> myListings({required bool sold}) {
    final result = _listings
        .where((l) => l.seller.id == currentUser.id && l.isSold == sold)
        .toList();
    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return result;
  }

  Listing? findById(String id) {
    for (final l in _listings) {
      if (l.id == id) return l;
    }
    return null;
  }

  void add({
    required String title,
    required String description,
    required int price,
    required ListingCategory category,
    required List<String> imageUrls,
  }) {
    _listings.add(
      Listing(
        id: 'l${_nextId++}',
        title: title,
        description: description,
        price: price,
        category: category,
        imageUrls: imageUrls,
        seller: currentUser,
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  void update(Listing updated) {
    final index = _listings.indexWhere((l) => l.id == updated.id);
    if (index == -1) return;
    _listings[index] = updated;
    notifyListeners();
  }

  void toggleSold(String id) {
    final listing = findById(id);
    if (listing == null) return;
    update(listing.copyWith(isSold: !listing.isSold));
  }

  /// Removes a listing and returns its old position, so it can be undone.
  int remove(String id) {
    final index = _listings.indexWhere((l) => l.id == id);
    if (index == -1) return -1;
    _listings.removeAt(index);
    notifyListeners();
    return index;
  }

  void restore(Listing listing, int index) {
    _listings.insert(index.clamp(0, _listings.length), listing);
    notifyListeners();
  }
}
