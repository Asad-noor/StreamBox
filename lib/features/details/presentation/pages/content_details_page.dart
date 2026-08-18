import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:streambox/app/router/routes.dart';
import 'package:streambox/core/widgets/states/async_value_view.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/catalog/domain/entities/episode.dart';
import 'package:streambox/features/details/presentation/providers/details_providers.dart';
import 'package:streambox/features/details/presentation/widgets/details_skeleton.dart';
import 'package:streambox/features/details/presentation/widgets/details_view.dart';
import 'package:streambox/features/details/presentation/widgets/favorite_button.dart';

/// Everything about one title, and the entry point into playback.
class ContentDetailsPage extends ConsumerWidget {
  const ContentDetailsPage({required this.contentId, super.key});

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(contentDetailsProvider(contentId));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Only offered once the record has loaded: favouriting a title that
        // failed to load would save an identifier the viewer has not seen.
        actions: [if (value.hasValue) FavoriteButton(contentId: contentId)],
      ),
      body: AsyncValueView(
        value: value,
        skeleton: const DetailsSkeleton(),
        onRetry: ref.read(contentDetailsProvider(contentId).notifier).retry,
        data: (details) => DetailsView(
          details: details,
          selectedSeasonIndex: ref.watch(selectedSeasonProvider(contentId)),
          onSeasonSelected: ref
              .read(selectedSeasonProvider(contentId).notifier)
              .select,
          onWatch: () => _play(context, details),
          onEpisodeTap: (episode) => _playEpisode(context, episode),
        ),
      ),
    );
  }

  void _play(BuildContext context, ContentDetails details) {
    final episode = details.firstEpisode;

    if (episode != null) {
      _playEpisode(context, episode);
      return;
    }

    PlayerRoute(
      contentId: details.id,
      title: details.title,
    ).push<void>(context);
  }

  /// Episodes are addressed by their own identifier, so the player resolves and
  /// resumes them independently of the series they belong to.
  void _playEpisode(BuildContext context, Episode episode) => PlayerRoute(
    contentId: episode.id,
    title: episode.title,
  ).push<void>(context);
}
