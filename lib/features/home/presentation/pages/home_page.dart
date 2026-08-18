import 'package:flutter/material.dart';
import 'package:streambox/core/widgets/placeholder_page.dart';

/// Landing screen: hero banner and content rails. Built in phase 3.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => const PlaceholderPage(
    title: 'Home',
    subtitle: 'Hero banner and content rails arrive in phase 3.',
  );
}
