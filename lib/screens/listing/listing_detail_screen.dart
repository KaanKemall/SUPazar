import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/listing_store.dart';
import '../../models/listing.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/info_row.dart';
import '../../widgets/listing_image.dart';
import '../../widgets/responsive_center.dart';

/// Screen 4: Listing Detail. Photos, price, description and seller contact.
class ListingDetailScreen extends StatefulWidget {
  const ListingDetailScreen({super.key, required this.listingId});

  final String listingId;

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  final _store = ListingStore.instance;
  int _photoIndex = 0;

  Future<void> _launch(Uri uri) async {
    final messenger = ScaffoldMessenger.of(context);
    final ok = await launchUrl(uri).catchError((_) => false);
    if (!ok) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not open ${uri.scheme} app')),
      );
    }
  }

  void _showContactSheet(Listing listing) {
    final seller = listing.seller;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Contact ${seller.name}', style: AppTextStyles.title),
            AppSpacing.gapSm,
            if (seller.phone != null)
              ListTile(
                leading: const Icon(Icons.phone, color: AppColors.primary),
                title: Text('Call ${seller.phone}'),
                onTap: () {
                  Navigator.pop(context);
                  _launch(
                    Uri(scheme: 'tel', path: seller.phone!.replaceAll(' ', '')),
                  );
                },
              ),
            ListTile(
              leading: const Icon(Icons.email, color: AppColors.primary),
              title: Text('Email ${seller.email}'),
              onTap: () {
                Navigator.pop(context);
                _launch(
                  Uri(
                    scheme: 'mailto',
                    path: seller.email,
                    query: 'subject=SUPazar: ${listing.title}',
                  ),
                );
              },
            ),
            AppSpacing.gapMd,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _store,
      builder: (context, _) {
        final listing = _store.findById(widget.listingId);
        if (listing == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('This listing was removed.')),
          );
        }
        final isMine = listing.seller.id == _store.currentUser.id;
        final photos = listing.imageUrls.isEmpty
            ? <String?>[null]
            : listing.imageUrls;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Listing'),
            actions: [
              if (isMine)
                IconButton(
                  tooltip: 'Edit listing',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Navigator.pushNamed(
                    context,
                    AppRoutes.editListing,
                    arguments: listing.id,
                  ),
                ),
            ],
          ),
          body: SingleChildScrollView(
            child: ResponsiveCenter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: PageView.builder(
                      itemCount: photos.length,
                      onPageChanged: (i) => setState(() => _photoIndex = i),
                      itemBuilder: (_, i) => ListingImage(source: photos[i]),
                    ),
                  ),
                  if (photos.length > 1)
                    _PageDots(count: photos.length, active: _photoIndex),
                  Padding(
                    padding: AppSpacing.screenPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (listing.isSold)
                          const Chip(
                            label: Text('SOLD'),
                            backgroundColor: AppColors.soldBadge,
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                        Text(listing.title, style: AppTextStyles.heading),
                        AppSpacing.gapXs,
                        Text(
                          Formatters.price(listing.price),
                          style: AppTextStyles.priceLarge,
                        ),
                        Text(
                          '${listing.category.label} · posted '
                          '${Formatters.timeAgo(listing.createdAt).toLowerCase()}',
                          style: AppTextStyles.caption,
                        ),
                        AppSpacing.gapLg,
                        const Text(
                          'Description',
                          style: AppTextStyles.sectionLabel,
                        ),
                        AppSpacing.gapXs,
                        Text(
                          listing.description.isEmpty
                              ? 'No description.'
                              : listing.description,
                          style: AppTextStyles.body,
                        ),
                        AppSpacing.gapLg,
                        const Text('Seller', style: AppTextStyles.sectionLabel),
                        Card(
                          child: Padding(
                            padding: AppSpacing.cardPadding,
                            child: Column(
                              children: [
                                InfoRow(
                                  icon: Icons.person_outline,
                                  label: 'Name',
                                  value: listing.seller.name,
                                ),
                                if (listing.seller.phone != null)
                                  InfoRow(
                                    icon: Icons.phone_outlined,
                                    label: 'Phone',
                                    value: listing.seller.phone!,
                                  ),
                                InfoRow(
                                  icon: Icons.email_outlined,
                                  label: 'Email',
                                  value: listing.seller.email,
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppSpacing.gapLg,
                        if (!isMine && !listing.isSold)
                          FilledButton.icon(
                            onPressed: () => _showContactSheet(listing),
                            icon: const Icon(Icons.chat_bubble_outline),
                            label: const Text('Contact seller'),
                          ),
                        if (isMine)
                          const Text(
                            'This is your listing. Use the edit button to change it.',
                            style: AppTextStyles.caption,
                          ),
                        AppSpacing.gapLg,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.active});

  final int count;
  final int active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < count; i++)
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == active ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: i == active ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
    );
  }
}
