import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/retry_policy.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/home/presentation/providers/home_providers.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

void main() {
  late FakeContentRepository repository;

  ProviderContainer buildContainer() {
    final container = ProviderContainer(
      // Matches the application's bootstrap: a failed provider must surface
      // its error rather than being retried in the background.
      retry: noAutomaticRetry,
      overrides: [contentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);

    // The notifier is auto-dispose. Without a listener it is torn down the
    // moment the test awaits, exactly as it would be with no widget mounted,
    // so the harness stands in for the screen.
    container.listen(homeFeedProvider, (_, _) {}, fireImmediately: true);

    return container;
  }

  setUp(() {
    repository = FakeContentRepository(feed: buildHomeFeed());
  });

  group('HomeFeedNotifier', () {
    test('starts loading and resolves to the feed', () async {
      final container = buildContainer();

      expect(container.read(homeFeedProvider), isA<AsyncLoading<HomeFeed>>());

      final feed = await container.read(homeFeedProvider.future);

      expect(feed, repository.feed);
    });

    test('surfaces a repository failure as an AsyncError', () async {
      repository.failure = const NetworkException();
      final container = buildContainer();

      await expectLater(
        container.read(homeFeedProvider.future),
        throwsA(isA<NetworkException>()),
      );

      expect(container.read(homeFeedProvider).hasError, isTrue);
      expect(container.read(homeFeedProvider).error, isA<NetworkException>());
    });

    test('refresh asks the repository to bypass its cache', () async {
      final container = buildContainer();
      await container.read(homeFeedProvider.future);

      await container.read(homeFeedProvider.notifier).refresh();

      expect(repository.forceRefreshCalls, [false, true]);
    });

    test('refresh keeps the previous feed on screen while it runs', () async {
      final container = buildContainer();
      final original = await container.read(homeFeedProvider.future);

      final pending = container.read(homeFeedProvider.notifier).refresh();

      // The old value must still be readable mid-flight, or the list collapses.
      expect(container.read(homeFeedProvider).value, original);

      await pending;
    });

    test('refresh replaces the feed with the new one', () async {
      final container = buildContainer();
      await container.read(homeFeedProvider.future);

      final replacement = buildHomeFeed(
        featured: buildContent(id: 'new', title: 'New Featured'),
      );
      repository.feed = replacement;

      await container.read(homeFeedProvider.notifier).refresh();

      expect(container.read(homeFeedProvider).value, replacement);
    });

    test('refresh surfaces a failure as an error state', () async {
      final container = buildContainer();
      await container.read(homeFeedProvider.future);

      repository.failure = const RequestTimeoutException();
      await container.read(homeFeedProvider.notifier).refresh();

      expect(
        container.read(homeFeedProvider).error,
        isA<RequestTimeoutException>(),
      );
    });

    test('retry recovers from a failed initial load', () async {
      repository.failure = const NetworkException();
      final container = buildContainer();

      await expectLater(
        container.read(homeFeedProvider.future),
        throwsA(isA<NetworkException>()),
      );

      repository.failure = null;
      await container.read(homeFeedProvider.notifier).retry();

      expect(container.read(homeFeedProvider).value, repository.feed);
      expect(container.read(homeFeedProvider).hasError, isFalse);
    });

    test('retry goes through a clean loading state', () async {
      repository.failure = const NetworkException();
      final container = buildContainer();

      await expectLater(
        container.read(homeFeedProvider.future),
        throwsA(isA<NetworkException>()),
      );

      repository.failure = null;
      final pending = container.read(homeFeedProvider.notifier).retry();

      expect(container.read(homeFeedProvider), isA<AsyncLoading<HomeFeed>>());
      expect(container.read(homeFeedProvider).hasValue, isFalse);

      await pending;
    });
  });
}
