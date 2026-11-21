import 'package:flutter/material.dart';

import '../../data/listing_store.dart';
import '../../models/category.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../widgets/category_filter_chips.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/listing_card.dart';
import '../../widgets/responsive_center.dart';

/// Screen 3: Home. All unsold listings, newest first,
/// with search by title and category filter.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onAddPressed});

  final VoidCallback onAddPressed;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _store = ListingStore.instance;
  final _searchController = TextEditingController();
  ListingCategory? _category;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', width: 32, height: 32),
            AppSpacing.gapSm,
            const Text('SUPazar'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddPressed,
        tooltip: 'Post a listing',
        child: const Icon(Icons.add),
      ),
      body: ResponsiveCenter(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                0,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search listings…',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () =>
                              setState(() => _searchController.clear()),
                        ),
                ),
              ),
            ),
            AppSpacing.gapSm,
            CategoryFilterChips(
              selected: _category,
              onSelected: (c) => setState(() => _category = c),
            ),
            Expanded(
              child: ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  final listings = _store.activeListings(
                    query: _searchController.text,
                    category: _category,
                  );
                  if (listings.isEmpty) {
                    return const EmptyState(
                      icon: Icons.search_off,
                      title: 'No listings found',
                      message: 'Try another search or category.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      88,
                    ),
                    itemCount: listings.length + 1,
                    separatorBuilder: (_, _) => AppSpacing.gapSm,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Text(
                          'Newest first · ${listings.length} '
                          '${listings.length == 1 ? 'listing' : 'listings'}',
                          style: AppTextStyles.sectionLabel,
                        );
                      }
                      final listing = listings[index - 1];
                      return ListingCard(
                        listing: listing,
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.listingDetail,
                          arguments: listing.id,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
