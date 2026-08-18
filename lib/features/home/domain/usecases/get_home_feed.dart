import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

/// Loads the home screen's feed.
///
/// A thin pass-through today. It exists because it is the seam where home's
/// composition rules will go — merging continue-watching from local playback
/// progress in phase 7, and ranking recommendations later — and putting it in
/// now means the notifier never has to be rewritten to accommodate that.
final class GetHomeFeedUseCase {
  const GetHomeFeedUseCase(this._repository);

  final ContentRepository _repository;

  Future<Result<HomeFeed>> call({bool forceRefresh = false}) =>
      _repository.getHomeFeed(forceRefresh: forceRefresh);
}
