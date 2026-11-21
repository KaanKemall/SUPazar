import '../models/app_user.dart';
import '../models/category.dart';
import '../models/listing.dart';

/// Placeholder data for Step 2. In Step 3 this will come from Firebase.
class SampleData {
  SampleData._();

  static final DateTime _now = DateTime.now();

  static final AppUser currentUser = AppUser(
    id: 'u1',
    name: 'Kaan Kemal Başkan',
    email: 'kaan@sabanciuniv.edu',
    phone: '0532 111 22 33',
    joinedAt: DateTime(2026, 10, 1),
  );

  static final AppUser can = AppUser(
    id: 'u2',
    name: 'Can Altay',
    email: 'can@sabanciuniv.edu',
    phone: '0533 444 55 66',
    joinedAt: DateTime(2026, 10, 3),
  );

  static final AppUser taha = AppUser(
    id: 'u3',
    name: 'Taha Dumanlı',
    email: 'taha@sabanciuniv.edu',
    joinedAt: DateTime(2026, 10, 5),
  );

  /// Local images bundled with the app (see pubspec.yaml).
  static const String _items = 'assets/images/items';

  /// Network images (loaded from the internet with Image.network).
  static String _network(int id) => 'https://picsum.photos/id/$id/800/600';

  /// Extra photos the "add photo" button on the form can pick from,
  /// since real photo picking comes with Firebase Storage in Step 3.
  static final List<String> demoPhotos = [
    '$_items/backpack.png',
    '$_items/kettle.png',
    _network(26),
    _network(96),
  ];

  static List<Listing> listings() => [
    Listing(
      id: 'l1',
      title: 'Calculus textbook',
      description:
          "Thomas' Calculus 14th edition, used for MATH101. Some notes in "
          'pencil, otherwise clean. Can meet at the FENS building.',
      price: 250,
      category: ListingCategory.books,
      imageUrls: ['$_items/calculus_book.png', _network(24)],
      seller: can,
      createdAt: _now.subtract(const Duration(hours: 2)),
    ),
    Listing(
      id: 'l2',
      title: 'Noise cancelling headphones',
      description:
          'Over-ear wireless headphones, about one year old. Battery still '
          'lasts a full day. Comes with the case and cable.',
      price: 900,
      category: ListingCategory.electronics,
      imageUrls: ['$_items/headphones.png', _network(367)],
      seller: taha,
      createdAt: _now.subtract(const Duration(hours: 5)),
    ),
    Listing(
      id: 'l3',
      title: 'Mini fridge',
      description:
          'Small fridge that fits under a dorm desk. Works perfectly, '
          'moving out at the end of the semester.',
      price: 1500,
      category: ListingCategory.dorm,
      imageUrls: ['$_items/mini_fridge.png'],
      seller: currentUser,
      createdAt: _now.subtract(const Duration(days: 1, hours: 3)),
    ),
    Listing(
      id: 'l4',
      title: 'Desk lamp',
      description: 'LED desk lamp with 3 brightness levels. USB powered.',
      price: 120,
      category: ListingCategory.dorm,
      imageUrls: ['$_items/desk_lamp.png'],
      seller: taha,
      createdAt: _now.subtract(const Duration(days: 2)),
    ),
    Listing(
      id: 'l5',
      title: 'Sabancı hoodie (M)',
      description: 'Navy university hoodie, size M. Worn a few times.',
      price: 350,
      category: ListingCategory.clothes,
      imageUrls: ['$_items/hoodie.png'],
      seller: currentUser,
      createdAt: _now.subtract(const Duration(days: 3)),
    ),
    Listing(
      id: 'l6',
      title: 'Electric kettle',
      description: '1.7 L kettle, perfect for tea in the dorm.',
      price: 200,
      category: ListingCategory.dorm,
      imageUrls: ['$_items/kettle.png'],
      seller: can,
      createdAt: _now.subtract(const Duration(days: 4)),
    ),
    Listing(
      id: 'l7',
      title: 'Old laptop for parts',
      description:
          'Screen works, battery is dead. Good for parts or as a home '
          'server project.',
      price: 2500,
      category: ListingCategory.electronics,
      imageUrls: [_network(0), _network(2)],
      seller: can,
      createdAt: _now.subtract(const Duration(days: 6)),
    ),
    Listing(
      id: 'l8',
      title: 'Backpack',
      description: 'Laptop backpack with many pockets. Fits a 15" laptop.',
      price: 300,
      category: ListingCategory.other,
      imageUrls: ['$_items/backpack.png'],
      seller: taha,
      createdAt: _now.subtract(const Duration(days: 8)),
    ),
    Listing(
      id: 'l9',
      title: 'Scientific calculator',
      description: 'Casio fx-991, allowed in MATH exams.',
      price: 400,
      category: ListingCategory.electronics,
      imageUrls: ['$_items/calculator.png'],
      seller: currentUser,
      createdAt: _now.subtract(const Duration(days: 10)),
      isSold: true,
    ),
  ];
}
