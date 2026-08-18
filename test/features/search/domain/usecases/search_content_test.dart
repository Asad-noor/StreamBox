import 'package:flutter_test/flutter_test.dart';
import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/features/catalog/domain/entities/search_results.dart';
import 'package:streambox/features/search/domain/usecases/search_content.dart';

import '../../../../support/content_fixtures.dart';
import '../../../../support/fake_content_repository.dart';

void main() {
  late FakeContentRepository repository;
  late SearchContentUseCase useCase;

  setUp(() {
    repository = FakeContentRepository()
      ..searchResults = SearchResults(
        items: [buildContent(id: 'a')],
        page: 0,
        hasMore: false,
        totalCount: 1,
      );
    useCase = SearchContentUseCase(repository);
  });

  group('SearchContentUseCase', () {
    test('returns the repository results', () async {
      final result = await useCase(query: 'harbour');

      expect(result.valueOrNull, repository.searchResults);
    });

    test('defaults to the first page', () async {
      await useCase(query: 'harbour');

      expect(repository.searchCalls.single.page, 0);
    });

    test('passes the requested page through', () async {
      await useCase(query: 'harbour', page: 3);

      expect(repository.searchCalls.single, (query: 'harbour', page: 3));
    });

    test('propagates failure unchanged', () async {
      repository.failure = const RequestTimeoutException();

      final result = await useCase(query: 'harbour');

      expect(result.errorOrNull, isA<RequestTimeoutException>());
    });
  });
}
