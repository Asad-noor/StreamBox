import 'package:flutter/material.dart';
import 'package:streambox/core/widgets/placeholder_page.dart';

/// Catalogue search. Built in phase 4.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
    title: 'Search',
    subtitle: 'Debounced search and pagination arrive in phase 4.',
  );
}
