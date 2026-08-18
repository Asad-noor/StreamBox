import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';

part 'content_snapshot.freezed.dart';

/// The minimum needed to render a title in a list.
///
/// Stored alongside favourites and watch history so those screens work with no
/// catalogue access at all. Without it, a device holding the data would still
/// need a network round trip to show a title, which defeats the point of
/// having stored anything.
///
/// It is rewritten on every interaction, so the entries a viewer touches most
/// are the ones whose snapshot is freshest.
@freezed
abstract class ContentSnapshot with _$ContentSnapshot {
  const factory ContentSnapshot({
    required String contentId,
    required String title,
    required String posterUrl,
    required int releaseYear,
  }) = _ContentSnapshot;

  const ContentSnapshot._();

  factory ContentSnapshot.fromContent(Content content) => ContentSnapshot(
    contentId: content.id,
    title: content.title,
    posterUrl: content.posterUrl,
    releaseYear: content.releaseYear,
  );
}
