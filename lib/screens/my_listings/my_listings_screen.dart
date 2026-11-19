import 'package:flutter/material.dart';

import '../../data/listing_store.dart';
import '../../models/listing.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_spacing.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/my_listing_card.dart';
import '../../widgets/responsive_center.dart';

/// Screen 6: My Listings. The user's own listings in Active and Sold tabs,
/// each card can be edited, marked as sold or deleted.
class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = ListingStore.instance;
    return ListenableBuilder(
      listenable: store,
      builder: (context, _) {
        final active = store.myListings(sold: false);
        final sold = store.myListings(sold: true);
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('My listings'),
              bottom: TabBar(
                tabs: [
                  Tab(text: 'Active (${active.length})'),
                  Tab(text: 'Sold (${sold.length})'),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _ListingList(
                  listings: active,
                  emptyTitle: 'No active listings',
                  emptyMessage: 'Tap Post to sell something.',
                ),
                _ListingList(
                  listings: sold,
                  emptyTitle: 'Nothing sold yet',
                  emptyMessage: 'Listings you mark as sold appear here.',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ListingList extends StatelessWidget {
  const _ListingList({
    required this.listings,
    required this.emptyTitle,
    required this.emptyMessage,
  });

  final List<Listing> listings;
  final String emptyTitle;
  final String emptyMessage;

  Future<void> _delete(BuildContext context, Listing listing) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Delete listing?',
      message: '"${listing.title}" will be removed. This can\'t be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;

    final store = ListingStore.instance;
    final index = store.remove(listing.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('Listing deleted'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () => store.restore(listing, index),
          ),
        ),
      );
  }

  void _toggleSold(BuildContext context, Listing listing) {
    ListingStore.instance.toggleSold(listing.id);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            listing.isSold
                ? '"${listing.title}" is active again'
                : '"${listing.title}" marked as sold',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return EmptyState(
        icon: Icons.inventory_2_outlined,
        title: emptyTitle,
        message: emptyMessage,
      );
    }
    return ResponsiveCenter(
      child: ListView.separated(
        padding: AppSpacing.screenPadding,
        itemCount: listings.length,
        separatorBuilder: (_, _) => AppSpacing.gapMd,
        itemBuilder: (context, index) {
          final listing = listings[index];
          return MyListingCard(
            key: ValueKey(listing.id),
            listing: listing,
            onTap: () => Navigator.pushNamed(
              context,
              AppRoutes.listingDetail,
              arguments: listing.id,
            ),
            onEdit: () => Navigator.pushNamed(
              context,
              AppRoutes.editListing,
              arguments: listing.id,
            ),
            onToggleSold: () => _toggleSold(context, listing),
            onDelete: () => _delete(context, listing),
          );
        },
      ),
    );
  }
}
