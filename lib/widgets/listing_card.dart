import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import '../utils/formatters.dart';
import 'listing_image.dart';

/// Card used on the Home screen: photo, title, price, category and date.
class ListingCard extends StatelessWidget {
  const ListingCard({super.key, required this.listing, required this.onTap});

  final Listing listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Row(
            children: [
              SizedBox.square(
                dimension: AppSpacing.thumbnailSize,
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppSpacing.gapXs,
                    Text(
                      Formatters.price(listing.price),
                      style: AppTextStyles.price,
                    ),
                    AppSpacing.gapXs,
                    Text(
                      '${listing.category.label} · '
                      '${Formatters.timeAgo(listing.createdAt)}',
                      style: AppTextStyles.caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
