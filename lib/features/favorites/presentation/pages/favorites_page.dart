import 'package:flutter/material.dart';
import 'package:streambox/core/widgets/placeholder_page.dart';

/// Locally persisted favourites. Built in phase 7.
class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
    title: 'Favourites',
    subtitle: 'Saved titles arrive in phase 7.',
  );
}
