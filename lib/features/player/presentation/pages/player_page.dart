import 'package:flutter/material.dart';
import 'package:streambox/core/widgets/placeholder_page.dart';

/// HLS playback surface. Built in phase 6.
class PlayerPage extends StatelessWidget {
  const PlayerPage({required this.contentId, super.key});

  final String contentId;

  @override
  Widget build(BuildContext context) => PlaceholderPage(
    title: 'Player',
    subtitle: 'HLS playback for "$contentId" arrives in phase 6.',
  );
}
