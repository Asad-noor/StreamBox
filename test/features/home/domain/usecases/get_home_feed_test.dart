import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/home/domain/usecases/get_home_feed.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

void main() {
  late FakeContentRepository repository;
  late GetHomeFeedUseCase useCase;

  setUp(() {
    repository = FakeContentRepository(feed: buildHomeFeed());
    useCase = GetHomeFeedUseCase(repository);
  });

  group('GetHomeFeedUseCase', () {
    test('returns the repository feed', () async {
      final result = await useCase();

      expect(result.valueOrNull, repository.feed);
    });

    test('defaults to using the cache', () async {
      await useCase();

      expect(repository.forceRefreshCalls, [false]);
    });

    test('passes forceRefresh through', () async {
      await useCase(forceRefresh: true);

      expect(repository.forceRefreshCalls, [true]);
    });

    test('propagates failure without converting it', () async {
      repository.failure = const NetworkException();

      final result = await useCase();

      expect(result.errorOrNull, isA<NetworkException>());
    });
  });
}
