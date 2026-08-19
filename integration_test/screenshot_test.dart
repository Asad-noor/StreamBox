import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:streambox/app/app.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/catalog/data/datasources/fake_content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:streambox/features/player/domain/entities/playback_progress.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';

/// Captures the screenshots the README uses.
///
/// Runs the real application — real router, real database, real playback
/// engine, real network artwork. Only the catalogue's simulated latency is
/// removed.
///
/// State that the screens merely *display* (saved titles, resume points) is
/// seeded through the repositories rather than by driving the UI. Clicking a
/// path through the app to arrange a screenshot turned out to be the fragile
/// part: a step that silently matched nothing produced an empty screen rather
/// than a failure. Seeding is deterministic, and navigation is then used only
/// for the screens actually being captured.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Network images and video arrive on real time, which the test clock does
  /// not advance, so frames have to be pumped against the wall clock.
  Future<void> settleFor(WidgetTester tester, Duration duration) async {
    const step = Duration(milliseconds: 100);
    var waited = Duration.zero;

    while (waited < duration) {
      await tester.pump(step);
      await Future<void>.delayed(step);
      waited += step;
    }
  }

  Future<void> capture(WidgetTester tester, String name) async {
    await settleFor(tester, const Duration(seconds: 1));
    await binding.takeScreenshot(name);
  }

  testWidgets('captures every screen the README shows', (tester) async {
    // Required on Android before any screenshot can be taken.
    await binding.convertFlutterSurfaceToImage();

    final container = createAppProviderContainer(
      overrides: [
        contentRemoteDataSourceProvider.overrideWithValue(
          const FakeContentRemoteDataSource(latency: Duration.zero),
        ),
      ],
    );
    addTearDown(container.dispose);

    final catalogue = container.read(contentRepositoryProvider);
    final favorites = container.read(favoritesRepositoryProvider);
    final progress = container.read(playbackProgressRepositoryProvider);

    // Saved titles, for the list screen.
    for (final id in ['harbour-lights', 'the-long-descent', 'signal-fire']) {
      final result = await catalogue.getContentById(id);
      if (result.valueOrNull case final content?) await favorites.add(content);
    }

    // Resume points, so Home shows a real Continue Watching rail.
    final resumePoints = {
      'low-tide': const Duration(minutes: 31),
      'paper-cities': const Duration(minutes: 12),
      'northlight': const Duration(minutes: 74),
    };

    for (final MapEntry(key: id, value: position) in resumePoints.entries) {
      final result = await catalogue.getContentById(id);
      if (result.valueOrNull case final content?) {
        await progress.saveProgress(
          content: ContentSnapshot.fromContent(content),
          progress: PlaybackProgress(
            contentId: id,
            position: position,
            duration: content.duration,
            updatedAt: DateTime.now(),
          ),
        );
      }
    }

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const StreamBoxApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Home: hero banner, Continue Watching, content rails.
    await settleFor(tester, const Duration(seconds: 6));
    await capture(tester, '01-home');

    // Search: results for a query matching several titles.
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'the');
    await settleFor(tester, const Duration(seconds: 4));
    await capture(tester, '02-search');

    // My list: the saved titles, rendered from their stored snapshots.
    await tester.tap(find.text('Favourites'));
    await tester.pumpAndSettle();
    await settleFor(tester, const Duration(seconds: 4));
    await capture(tester, '05-my-list');

    // Details: a series, so the season selector and episode list are shown.
    await tester.tap(find.text('Harbour Lights'));
    await tester.pumpAndSettle();
    await settleFor(tester, const Duration(seconds: 5));
    await capture(tester, '03-details');

    // Player: real HLS. The controls fade on their own, so they are brought
    // back before capturing.
    await tester.tap(find.textContaining('Play S1'));
    await tester.pumpAndSettle();
    await settleFor(tester, const Duration(seconds: 8));
    await tester.tapAt(const Offset(60, 200));
    await settleFor(tester, const Duration(milliseconds: 400));
    await capture(tester, '04-player');
  });
}
