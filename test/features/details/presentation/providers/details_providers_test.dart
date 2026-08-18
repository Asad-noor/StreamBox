import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/riverpod/app_provider_scope.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/details/presentation/providers/details_providers.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

void main() {
  late FakeContentRepository repository;

  ProviderContainer buildContainer(String contentId) {
    final container = createAppProviderContainer(
      overrides: [contentRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    container.listen(
      contentDetailsProvider(contentId),
      (_, _) {},
      fireImmediately: true,
    );

    return container;
  }

  setUp(() {
    repository = FakeContentRepository()..details = buildSeriesDetails();
  });

  group('ContentDetailsNotifier', () {
    test('loads the record for its identifier', () async {
      final container = buildContainer('series-1');

      final details = await container.read(
        contentDetailsProvider('series-1').future,
      );

      expect(details, repository.details);
      expect(repository.detailsCalls, ['series-1']);
    });

    test('surfaces a failure as an error state', () async {
      repository.failure = const NotFoundException();
      final container = buildContainer('missing');

      await expectLater(
        container.read(contentDetailsProvider('missing').future),
        throwsA(isA<NotFoundException>()),
      );
      expect(
        container.read(contentDetailsProvider('missing')).hasError,
        isTrue,
      );
    });

    test('retry recovers after a failure', () async {
      repository.failure = const NetworkException();
      final container = buildContainer('series-1');

      await expectLater(
        container.read(contentDetailsProvider('series-1').future),
        throwsA(isA<NetworkException>()),
      );

      repository.failure = null;
      await container.read(contentDetailsProvider('series-1').notifier).retry();

      expect(
        container.read(contentDetailsProvider('series-1')).value,
        repository.details,
      );
    });

    test('two identifiers hold independent state', () async {
      final container = createAppProviderContainer(
        overrides: [contentRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      container.listen(
        contentDetailsProvider('a'),
        (_, _) {},
        fireImmediately: true,
      );
      container.listen(
        contentDetailsProvider('b'),
        (_, _) {},
        fireImmediately: true,
      );

      await container.read(contentDetailsProvider('a').future);
      await container.read(contentDetailsProvider('b').future);

      expect(repository.detailsCalls, ['a', 'b']);
    });
  });

  group('SelectedSeason', () {
    test('starts on the first season', () {
      final container = buildContainer('series-1');

      expect(container.read(selectedSeasonProvider('series-1')), 0);
    });

    test('records a selection', () {
      final container = buildContainer('series-1');

      container.read(selectedSeasonProvider('series-1').notifier).select(2);

      expect(container.read(selectedSeasonProvider('series-1')), 2);
    });

    test('selection is per title', () {
      final container = buildContainer('series-1');

      container.read(selectedSeasonProvider('series-1').notifier).select(2);

      expect(container.read(selectedSeasonProvider('other')), 0);
    });

    test('changing season does not refetch the record', () async {
      final container = buildContainer('series-1');
      await container.read(contentDetailsProvider('series-1').future);

      container.read(selectedSeasonProvider('series-1').notifier).select(1);
      await Future<void>.delayed(Duration.zero);

      // View state must not invalidate loaded data.
      expect(repository.detailsCalls, hasLength(1));
      expect(
        container.read(contentDetailsProvider('series-1')).value,
        isA<ContentDetails>(),
      );
    });
  });
}
