import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/app/theme/app_theme.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/core/widgets/states/app_error_view.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/details/presentation/pages/content_details_page.dart';
import 'package:streambox/features/details/presentation/widgets/details_skeleton.dart';
import 'package:streambox/features/details/presentation/widgets/episode_tile.dart';
import 'package:streambox/features/details/presentation/widgets/favorite_button.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';
import '../../../../support/offline_image_http_overrides.dart';

void main() {
  late FakeContentRepository repository;

  Future<ProviderContainer> pumpDetails(
    WidgetTester tester, {
    String contentId = 'series-1',
  }) async {
    useOfflineImages();
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = createAppProviderContainer(
      overrides: [contentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: ContentDetailsPage(contentId: contentId),
        ),
      ),
    );

    return container;
  }

  setUp(() {
    repository = FakeContentRepository()..details = buildSeriesDetails();
  });

  group('loading and failure', () {
    testWidgets('shows the skeleton first', (tester) async {
      await pumpDetails(tester);

      expect(find.byType(DetailsSkeleton), findsOneWidget);

      await tester.pumpAndSettle();
    });

    testWidgets('shows the error view and recovers on retry', (tester) async {
      repository.failure = const NetworkException();
      await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsOneWidget);

      repository.failure = null;
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      expect(find.byType(AppErrorView), findsNothing);
      expect(find.text('Harbour Lights'), findsOneWidget);
    });

    testWidgets('hides the favourite action until the record loads', (
      tester,
    ) async {
      repository.failure = const NotFoundException();
      await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(find.byType(FavoriteButton), findsNothing);
    });
  });

  group('a movie', () {
    setUp(() {
      repository.details = buildMovieDetails(
        content: buildContent(
          id: 'movie-1',
          title: 'The Long Descent',
          releaseYear: 2026,
          genres: ['Sci-fi', 'Thriller'],
          duration: const Duration(minutes: 112),
        ),
      );
    });

    testWidgets('shows title, genres, runtime and synopsis', (tester) async {
      await pumpDetails(tester, contentId: 'movie-1');
      await tester.pumpAndSettle();

      expect(find.text('The Long Descent'), findsOneWidget);
      expect(find.text('Sci-fi'), findsOneWidget);
      expect(find.text('Thriller'), findsOneWidget);
      expect(find.textContaining('1h 52m'), findsWidgets);
      expect(find.text('A synopsis.'), findsOneWidget);
    });

    testWidgets('offers a plain Watch action and no episodes', (tester) async {
      await pumpDetails(tester, contentId: 'movie-1');
      await tester.pumpAndSettle();

      expect(find.text('Watch'), findsOneWidget);
      expect(find.byType(EpisodeTile), findsNothing);
    });

    testWidgets('disables Watch when there is no stream', (tester) async {
      repository.details = buildMovieDetails(
        content: buildContent(id: 'movie-1', streamUrl: null),
      );
      await pumpDetails(tester, contentId: 'movie-1');
      await tester.pumpAndSettle();

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.onPressed, isNull);
    });
  });

  group('a series', () {
    testWidgets('names the first episode on the Watch action', (tester) async {
      await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(find.text('Play S1 E1'), findsOneWidget);
    });

    testWidgets('lists the selected season\'s episodes', (tester) async {
      await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(find.byType(EpisodeTile), findsNWidgets(3));
      expect(find.text('1. Episode 1'), findsOneWidget);
    });

    testWidgets('switching season replaces the episode list', (tester) async {
      repository.details = buildSeriesDetails(
        seasons: [
          buildSeason(
            number: 1,
            episodes: [buildEpisode(id: 's1e1', title: 'First season only')],
          ),
          buildSeason(
            number: 2,
            episodes: [buildEpisode(id: 's2e1', title: 'Second season only')],
          ),
        ],
      );

      await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(find.text('1. First season only'), findsOneWidget);

      await tester.tap(find.byType(DropdownButton<int>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Season 2 · 1 episodes').last);
      await tester.pumpAndSettle();

      expect(find.text('1. Second season only'), findsOneWidget);
      expect(find.text('1. First season only'), findsNothing);
      // Switching a season is view state; it must not refetch.
      expect(repository.detailsCalls, hasLength(1));
    });

    testWidgets('hides the selector for a single-season series', (
      tester,
    ) async {
      repository.details = buildSeriesDetails(seasons: [buildSeason()]);

      await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(find.byType(DropdownButton<int>), findsNothing);
      expect(find.byType(EpisodeTile), findsNWidgets(3));
    });
  });

  group('favourites', () {
    testWidgets('toggles on and off', (tester) async {
      final container = await pumpDetails(tester);
      await tester.pumpAndSettle();

      expect(container.read(isFavoriteProvider('series-1')), isFalse);

      await tester.tap(find.text('My list'));
      await tester.pumpAndSettle();

      expect(container.read(isFavoriteProvider('series-1')), isTrue);
      expect(find.text('In my list'), findsOneWidget);

      await tester.tap(find.text('In my list'));
      await tester.pumpAndSettle();

      expect(container.read(isFavoriteProvider('series-1')), isFalse);
    });

    testWidgets('the app bar action reflects the same state', (tester) async {
      await pumpDetails(tester);
      await tester.pumpAndSettle();

      await tester.tap(find.text('My list'));
      await tester.pumpAndSettle();

      // Both the labelled button and the app-bar icon read one provider.
      expect(find.byType(FavoriteButton), findsNWidgets(2));
      expect(find.byIcon(Icons.check_rounded), findsNWidgets(2));
    });
  });
}
