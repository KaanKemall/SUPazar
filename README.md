# SUPazar

SUPazar is a buy and sell app for Sabancı University students. Students can post things they don't need anymore (textbooks, electronics, dorm stuff, clothes) and other students can search for them and contact the seller to meet on campus.

We are building it with Flutter and Firebase for the CS310 Mobile Application Development course.

## Main features

- Sign up and log in with email and password
- Post a listing with title, description, price, category and photos
- Browse the newest listings on the home page
- Search by title and filter by category
- See listing details and the seller's contact info
- Edit, delete or mark your own listings as sold

## Step 2.2 status

This step is the UI only. All data is placeholder data kept in memory
(`lib/data/sample_data.dart`). Login and sign up only validate the form,
real authentication and Firebase come in Step 3.

## How to run

Flutter version used: **3.47.5 (stable)**, Dart 3.13.4.

```bash
git clone https://github.com/KaanKemall/SUPazar.git
cd SUPazar
flutter pub get
flutter run        # with an Android emulator or iOS simulator running
```

Any valid looking email and a password of at least 6 characters logs you in.
Listing photos marked as network images need an internet connection; if there
is none, a placeholder image is shown instead.

To run the widget tests (they check every screen on a small and a large phone
for overflow errors, and test the form and delete flows):

```bash
flutter test
```

## Project structure

```
lib/
  main.dart                 app entry, theme and routes
  routes/app_routes.dart    named routes
  utils/                    shared colors, text styles, spacing, theme, validators, formatters
  models/                   Listing, AppUser, ListingCategory
  data/                     placeholder data and the in-memory ListingStore
  widgets/                  reusable widgets (cards, text field, dialogs, image, chips...)
  screens/
    auth/                   1. Login, 2. Sign Up
    home/                   3. Home (search + category filter)
    listing/                4. Listing Detail, 5. Post Listing / 5b. Edit Listing
    my_listings/            6. My Listings (Active / Sold, edit, mark sold, delete)
    profile/                7. Profile
    main_shell.dart         bottom navigation (Home, Post, My Listings, Profile)
assets/
  images/                   logo, placeholder and local listing images
  fonts/                    Poppins (custom font, SIL Open Font License)
test/screens_test.dart      overflow and flow tests
```

## Group 17

| Name | Student ID |
| --- | --- |
| Kaan Kemal Başkan | 35330 |
| Taha Dumanlı | 30981 |
| Can Altay | 34388 |
