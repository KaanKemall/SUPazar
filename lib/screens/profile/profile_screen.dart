import 'package:flutter/material.dart';

import '../../data/listing_store.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_spacing.dart';
import '../../utils/app_text_styles.dart';
import '../../utils/formatters.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/info_row.dart';
import '../../widgets/responsive_center.dart';

/// Screen 7: Profile. The contact info buyers see, plus Log out.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _logOut(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Log out?',
      message: 'You will go back to the login screen.',
      confirmLabel: 'Log out',
    );
    if (!confirmed || !context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final store = ListingStore.instance;
    final user = store.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.screenPadding,
        child: ResponsiveCenter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.gapMd,
              Center(
                child: CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    user.initials,
                    style: AppTextStyles.heading.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ),
              AppSpacing.gapMd,
              Text(
                user.name,
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              Text(
                'Member since ${Formatters.monthYear(user.joinedAt)}',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapLg,
              Card(
                child: Padding(
                  padding: AppSpacing.cardPadding,
                  child: Column(
                    children: [
                      InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: user.email,
                      ),
                      InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Phone',
                        value: user.phone ?? 'Not added',
                      ),
                      ListenableBuilder(
                        listenable: store,
                        builder: (context, _) => InfoRow(
                          icon: Icons.sell_outlined,
                          label: 'Listings',
                          value:
                              '${store.myListings(sold: false).length} active · '
                              '${store.myListings(sold: true).length} sold',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.gapSm,
              const Text(
                'This is the contact info buyers see on your listings.',
                style: AppTextStyles.caption,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapLg,
              OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Editing your profile comes with Firebase in Step 3',
                    ),
                  ),
                ),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit profile'),
              ),
              AppSpacing.gapSm,
              FilledButton.icon(
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () => _logOut(context),
                icon: const Icon(Icons.logout),
                label: const Text('Log out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
