import 'package:flutter/material.dart';

import 'home/home_screen.dart';
import 'listing/listing_form_screen.dart';
import 'my_listings/my_listings_screen.dart';
import 'profile/profile_screen.dart';

/// Holds the four bottom navigation tabs:
/// Home, Post, My Listings and Profile.
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  static const int homeTab = 0;
  static const int postTab = 1;
  static const int myListingsTab = 2;

  int _index = homeTab;

  void _goTo(int index) => setState(() => _index = index);

  void _onPublished() {
    _goTo(myListingsTab);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Listing published')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(onAddPressed: () => _goTo(postTab)),
          ListingFormScreen(onPublished: _onPublished),
          const MyListingsScreen(),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _goTo,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.add_box_outlined),
            selectedIcon: Icon(Icons.add_box),
            label: 'Post',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_alt_outlined),
            selectedIcon: Icon(Icons.list_alt),
            label: 'My Listings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
