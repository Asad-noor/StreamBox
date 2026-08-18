import 'package:flutter/material.dart';
import 'package:streambox/core/widgets/placeholder_page.dart';

/// Metadata, seasons, and playback entry point for one title. Built in phase 5.
class ContentDetailsPage extends StatelessWidget {
  const ContentDetailsPage({required this.contentId, super.key});

  final String contentId;

  @override
  Widget build(BuildContext context) => PlaceholderPage(
    title: 'Details',
    subtitle: 'Metadata and seasons for "$contentId" arrive in phase 5.',
  );
}
