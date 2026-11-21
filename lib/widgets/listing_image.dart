import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

/// Shows a listing photo. Paths starting with "assets/" are loaded with
/// Image.asset (local image), everything else with Image.network.
class ListingImage extends StatelessWidget {
  const ListingImage({
    super.key,
    required this.source,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
  });

  static const String placeholder = 'assets/images/placeholder.png';

  final String? source;
  final BoxFit fit;
  final BorderRadius borderRadius;

  bool get _isLocal => source == null || source!.startsWith('assets/');

  @override
  Widget build(BuildContext context) {
    final Widget image;
    if (_isLocal) {
      image = Image.asset(
        source ?? placeholder,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) => _fallback(),
      );
    } else {
      image = Image.network(
        source!,
        fit: fit,
        width: double.infinity,
        height: double.infinity,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const ColoredBox(
            color: AppColors.border,
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (_, _, _) => _fallback(),
      );
    }
    return ClipRRect(borderRadius: borderRadius, child: image);
  }

  Widget _fallback() => Image.asset(
    placeholder,
    fit: fit,
    width: double.infinity,
    height: double.infinity,
  );
}
