/// A SUPazar user. The contact info here is what buyers see on a listing.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.joinedAt,
  });

  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime joinedAt;

  String get initials {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }
}
