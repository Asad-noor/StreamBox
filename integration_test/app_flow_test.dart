import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:streambox/app/app.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/catalog/data/datasources/fake_content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/details/presentation/pages/content_details_page.dart';
import 'package:streambox/features/details/presentation/widgets/episode_tile.dart';
import 'package:streambox/features/home/presentation/pages/home_page.dart';
import 'package:streambox/features/player/presentation/pages/player_page.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';
import 'package:streambox/features/player/presentation/widgets/player_controls.dart';
import 'package:streambox/features/search/presentation/pages/search_page.dart';
import 'package:streambox/features/search/presentation/widgets/search_result_tile.dart';

// Shared with the unit tests rather than duplicated, so the fake cannot
// drift out of step with the engine interface it stands in for.
import '../test/support/fake_playback_engine.dart';

/// End-to-end journey through the real application.
///
/// Runs on a device or emulator: `flutter test integration_test`.
///
/// The real router, theme, notifiers, repositories and database are all in
/// play. Two things are substituted, both deliberately:
///
/// * the catalogue source drops its simulated latency, so the test is not
///   waiting on an artificial delay;
/// * the playback engine is a fake, so the test does not depend on a public
///   stream, a network connection or a hardware codec being available on
///   whatever machine runs it.
///
/// Everything between the tap and the player — routing, state, persistence —
/// is the production code path.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FakePlaybackEngine engine;

  Future<void> launchApp(WidgetTester tester) async {
    engine = FakePlaybackEngine();

    await tester.pumpWidget(
      AppProviderScope(
        overrides: [
          contentRemoteDataSourceProvider.overrideWithValue(
            const FakeContentRemoteDataSource(latency: Duration.zero),
          ),
          playbackEngineProvider.overrideWith((ref, contentId) => engine),
        ],
        child: const StreamBoxApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('StreamBox', () {
    testWidgets('launch, search, open details, start playback', (tester) async {
      await launchApp(tester);

      // Launch -> Home
      expect(find.byType(HomePage), findsOneWidget);

      // Home -> Search
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchPage), findsOneWidget);

      // Search for a known title and wait out the debounce.
      await tester.enterText(find.byType(TextField), 'harbour');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      expect(find.byType(SearchResultTile), findsWidgets);
      expect(find.text('Harbour Lights'), findsWidgets);

      // Search -> Details
      await tester.tap(find.byType(SearchResultTile).first);
      await tester.pumpAndSettle();

      expect(find.byType(ContentDetailsPage), findsOneWidget);
      expect(find.byType(EpisodeTile), findsWidgets);

      // Details -> Player
      await tester.tap(find.textContaining('Play S1'));
      await tester.pumpAndSettle();

      expect(find.byType(PlayerPage), findsOneWidget);
      expect(find.byType(PlayerControls), findsOneWidget);
      expect(engine.loadedUrls, isNotEmpty);
    });

    testWidgets('saving a title makes it appear on the list tab', (
      tester,
    ) async {
      await launchApp(tester);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'harbour');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SearchResultTile).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('My list'));
      await tester.pumpAndSettle();
      expect(find.text('In my list'), findsOneWidget);

      // Back to the shell, then over to the favourites tab.
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Favourites'));
      await tester.pumpAndSettle();

      // The write went through the real database and the real stream.
      expect(find.text('Harbour Lights'), findsWidgets);
    });

    testWidgets('watching a title puts it in Continue watching', (
      tester,
    ) async {
      await launchApp(tester);

      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'long descent');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SearchResultTile).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Watch'));
      await tester.pumpAndSettle();

      // Advance far enough that the throttled write commits.
      engine.tickTo(const Duration(minutes: 4));
      await tester.pumpAndSettle();

      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('Continue watching'), findsOneWidget);
    });
  });
}
