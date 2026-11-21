// Pumps every screen on a small and a large phone in portrait mode.
// The test fails if any screen shows an overflow error (or any other
// rendering exception). Run with: flutter test
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supazar/main.dart';
import 'package:supazar/models/category.dart';
import 'package:supazar/routes/app_routes.dart';
import 'package:supazar/utils/app_theme.dart';

const _sizes = {
  'small phone (320x568)': Size(320, 568),
  'large phone (430x932)': Size(430, 932),
};

Future<void> _pumpRoute(
  WidgetTester tester,
  Size size,
  String route, {
  Object? args,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light,
      onGenerateRoute: (s) => AppRoutes.onGenerateRoute(
        RouteSettings(name: route, arguments: args),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final entry in _sizes.entries) {
    group(entry.key, () {
      final size = entry.value;

      testWidgets('Login', (t) => _pumpRoute(t, size, AppRoutes.login));
      testWidgets('Sign up', (t) => _pumpRoute(t, size, AppRoutes.signUp));
      testWidgets(
        'Listing detail',
        (t) => _pumpRoute(t, size, AppRoutes.listingDetail, args: 'l1'),
      );
      testWidgets(
        'Edit listing',
        (t) => _pumpRoute(t, size, AppRoutes.editListing, args: 'l3'),
      );

      testWidgets('Main tabs: Home, Post, My Listings, Profile', (t) async {
        await _pumpRoute(t, size, AppRoutes.main);
        expect(find.text('Calculus textbook'), findsOneWidget);
        for (final tab in ['Post', 'My Listings', 'Profile', 'Home']) {
          await t.tap(find.text(tab).last);
          await t.pumpAndSettle();
        }
      });

      testWidgets('Login form shows inline errors', (t) async {
        await _pumpRoute(t, size, AppRoutes.login);
        await t.tap(find.text('Log in'));
        await t.pumpAndSettle();
        expect(find.text('Email is required'), findsOneWidget);
        expect(find.text('Password is required'), findsOneWidget);
      });
    });
  }

  testWidgets('Post form validates, confirms and publishes', (t) async {
    await _pumpRoute(t, const Size(400, 860), AppRoutes.main);
    await t.tap(find.text('Post').last);
    await t.pumpAndSettle();

    await t.tap(find.text('Publish'));
    await t.pumpAndSettle();
    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Price is required'), findsOneWidget);
    expect(find.text('Category is required'), findsOneWidget);

    await t.enterText(find.byType(TextFormField).at(0), 'Physics notes');
    await t.enterText(find.byType(TextFormField).at(2), '80');
    await t.ensureVisible(
      find.byType(DropdownButtonFormField<ListingCategory>),
    );
    await t.pumpAndSettle();
    await t.tap(find.byType(DropdownButtonFormField<ListingCategory>));
    await t.pumpAndSettle();
    await t.tap(find.text('Books').last);
    await t.pumpAndSettle();
    await t.tap(find.text('Publish'));
    await t.pumpAndSettle();
    expect(find.text('Publish listing?'), findsOneWidget);

    await t.tap(find.widgetWithText(FilledButton, 'Publish').last);
    await t.pumpAndSettle();
    expect(find.text('Listing published'), findsOneWidget);
    expect(find.text('Physics notes'), findsOneWidget); // now in My Listings
  });

  testWidgets('Delete removes the card after confirmation', (t) async {
    await _pumpRoute(t, const Size(400, 860), AppRoutes.main);
    await t.tap(find.text('My Listings').last);
    await t.pumpAndSettle();
    expect(find.text('Mini fridge'), findsOneWidget);

    await t.tap(find.text('Delete').first);
    await t.pumpAndSettle();
    expect(find.text('Delete listing?'), findsOneWidget);
    await t.tap(find.widgetWithText(FilledButton, 'Delete'));
    await t.pumpAndSettle();
    expect(find.text('Listing deleted'), findsOneWidget);
  });

  testWidgets('App starts on the login screen', (t) async {
    await t.pumpWidget(const SUPazarApp());
    await t.pumpAndSettle();
    expect(find.text('Buy & sell on campus'), findsOneWidget);
  });
}
