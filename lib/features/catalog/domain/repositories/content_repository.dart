import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/home_feed.dart';

/// The catalogue's contract with the rest of the application.
///
/// Lives in the domain layer and names no infrastructure, so the presentation
/// layer can be tested against a hand-written fake and the implementation can
/// move from a local source to a REST API without anything above it changing.
///
/// Methods return [Result] rather than throwing: callers are forced by the
/// type system to handle failure.
abstract interface class ContentRepository {
  /// Everything the home screen needs, in one call.
  Future<Result<HomeFeed>> getHomeFeed({bool forceRefresh = false});

  /// A single title, for the details screen and for resuming playback.
  Future<Result<Content>> getContentById(String id);
}
