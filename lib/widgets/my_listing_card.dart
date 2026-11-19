import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';
import 'listing_image.dart';

/// Card used on My Listings, with Edit, Mark sold and Delete actions.
class MyListingCard extends StatelessWidget {
  const MyListingCard({
    super.key,
    required this.listing,
    required this.onTap,
    required this.onEdit,
    required this.onToggleSold,
    required this.onDelete,
  });

  final Listing listing;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onToggleSold;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 64,
                    child: ListingImage(
                      source: listing.coverImage,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                  ),
                  AppSpacing.gapMd,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          style: AppTextStyles.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AppSpacing.gapXs,
                        Text(
                          '${Formatters.price(listing.price)} · '
                          '${listing.category.label}',
                          style: AppTextStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          Row(
            children: [
              _ActionButton(
                icon: Icons.edit_outlined,
                label: 'Edit',
                onPressed: onEdit,
              ),
              _ActionButton(
                icon: listing.isSold ? Icons.undo : Icons.check_circle_outline,
                label: listing.isSold ? 'Relist' : 'Mark sold',
                onPressed: onToggleSold,
              ),
              _ActionButton(
                icon: Icons.delete_outline,
                label: 'Delete',
                color: AppColors.error,
                onPressed: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color = AppColors.primary,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(foregroundColor: color),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18),
            AppSpacing.gapXs,
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
