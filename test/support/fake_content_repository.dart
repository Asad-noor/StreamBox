import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

/// Hand-written stand-in for [ContentRepository].
///
/// Preferred over a generated mock: the call recording is explicit, and the
/// tests read as descriptions of behaviour rather than of a mocking API.
final class FakeContentRepository implements ContentRepository {
  FakeContentRepository({this.feed, this.failure, this.content});

  /// Returned by [getHomeFeed] when [failure] is null.
  HomeFeed? feed;

  /// Returned by [getContentById] when [failure] is null.
  Content? content;

  /// When set, every call fails with this.
  AppException? failure;

  /// How many times [getHomeFeed] has been called.
  int homeFeedCalls = 0;

  /// The `forceRefresh` argument of each [getHomeFeed] call, in order.
  final List<bool> forceRefreshCalls = [];

  @override
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false}) async {
    homeFeedCalls++;
    forceRefreshCalls.add(forceRefresh);

    if (failure case final failure?) return Failure(failure);

    return Success(feed!);
  }

  @override
  Future<Result<Content>> getContentById(String id) async {
    if (failure case final failure?) return Failure(failure);

    return Success(content!);
  }
}
