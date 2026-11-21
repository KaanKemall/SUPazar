import 'package:flutter/material.dart';

import '../models/category.dart';
import '../utils/app_colors.dart';
import '../utils/app_spacing.dart';

/// Horizontal list of category chips. A null [selected] means "All".
class CategoryFilterChips extends StatelessWidget {
  const CategoryFilterChips({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final ListingCategory? selected;
  final ValueChanged<ListingCategory?> onSelected;

  @override
  Widget build(BuildContext context) {
    final options = <ListingCategory?>[null, ...ListingCategory.values];
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: options.length,
        separatorBuilder: (_, _) => AppSpacing.gapSm,
        itemBuilder: (context, index) {
          final category = options[index];
          final isSelected = category == selected;
          return Center(
            child: ChoiceChip(
              label: Text(category?.label ?? 'All'),
              selected: isSelected,
              showCheckmark: false,
              selectedColor: AppColors.chipSelected,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.onPrimary : AppColors.textPrimary,
              ),
              onSelected: (_) => onSelected(category),
            ),
          );
        },
      ),
    );
  }
}
