import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content_details.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

/// Loads the full record for one title.
final class GetContentDetailsUseCase {
  const GetContentDetailsUseCase(this._repository);

  final ContentRepository _repository;

  Future<Result<ContentDetails>> call(String contentId) =>
      _repository.getContentDetails(contentId);
}
