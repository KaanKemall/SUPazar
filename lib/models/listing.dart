import 'app_user.dart';
import 'category.dart';

/// One item for sale. [imageUrls] can hold local asset paths
/// (starting with "assets/") or network URLs, max 3 photos.
class Listing {
  const Listing({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.seller,
    required this.createdAt,
    this.isSold = false,
  });

  static const int maxPhotos = 3;

  final String id;
  final String title;
  final String description;
  final int price;
  final ListingCategory category;
  final List<String> imageUrls;
  final AppUser seller;
  final DateTime createdAt;
  final bool isSold;

  String? get coverImage => imageUrls.isEmpty ? null : imageUrls.first;

  Listing copyWith({
    String? title,
    String? description,
    int? price,
    ListingCategory? category,
    List<String>? imageUrls,
    bool? isSold,
  }) {
    return Listing(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      seller: seller,
      createdAt: createdAt,
      isSold: isSold ?? this.isSold,
    );
  }
}
