import 'package:flutter/material.dart';

import '../screens/auth/login_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/listing/listing_detail_screen.dart';
import '../screens/listing/listing_form_screen.dart';
import '../screens/main_shell.dart';

/// Named routes of the app. Screens navigate with
/// Navigator.pushNamed(context, AppRoutes.xxx, arguments: ...).
class AppRoutes {
  AppRoutes._();

  static const String login = '/';
  static const String signUp = '/signup';
  static const String main = '/main';
  static const String listingDetail = '/listing';
  static const String editListing = '/listing/edit';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return _page(const LoginScreen(), settings);
      case signUp:
        return _page(const SignUpScreen(), settings);
      case main:
        return _page(const MainShell(), settings);
      case listingDetail:
        return _page(
          ListingDetailScreen(listingId: settings.arguments as String),
          settings,
        );
      case editListing:
        return _page(
          ListingFormScreen(listingId: settings.arguments as String),
          settings,
        );
      default:
        return _page(const LoginScreen(), settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(Widget child, RouteSettings s) =>
      MaterialPageRoute(builder: (_) => child, settings: s);
}
