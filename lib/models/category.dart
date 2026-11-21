import 'package:flutter/material.dart';

/// Listing categories from the Step 1 proposal.
enum ListingCategory {
  books('Books', Icons.menu_book),
  electronics('Electronics', Icons.headphones),
  dorm('Dorm Stuff', Icons.bed),
  clothes('Clothes', Icons.checkroom),
  other('Other', Icons.category);

  const ListingCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}
