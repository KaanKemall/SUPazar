import 'package:flutter/material.dart';

import '../models/listing.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';
import '../utils/app_text_styles.dart';
import 'listing_image.dart';

/// Row of up to 3 photo thumbnails with remove buttons and an "add" tile.
/// In Step 2 "add" picks a demo photo; camera/gallery comes in Step 3.
class PhotoPickerRow extends StatelessWidget {
  const PhotoPickerRow({
    super.key,
    required this.photos,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> photos;
  final VoidCallback onAdd;
  final ValueChanged<int> onRemove;

  static const double _tile = 80;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Photos (${photos.length}/${Listing.maxPhotos})',
          style: AppTextStyles.sectionLabel,
        ),
        AppSpacing.gapXs,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (int i = 0; i < photos.length; i++)
              SizedBox.square(
                dimension: _tile,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ListingImage(
                      source: photos[i],
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: InkWell(
                        onTap: () => onRemove(i),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.black54,
                          child: Icon(
                            Icons.close,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (photos.length < Listing.maxPhotos)
              InkWell(
                onTap: onAdd,
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                child: Container(
                  width: _tile,
                  height: _tile,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.border, width: 1.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                  child: const Icon(
                    Icons.add_a_photo_outlined,
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        AppSpacing.gapMd,
      ],
    );
  }
}
