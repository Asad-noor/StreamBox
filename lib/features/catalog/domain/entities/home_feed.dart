import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_section.dart';

part 'home_feed.freezed.dart';

/// Everything the home screen renders, resolved in one round trip.
///
/// Modelled as a single entity rather than a list of independent requests so
/// the screen has one loading state and one error state instead of six.
@freezed
abstract class HomeFeed with _$HomeFeed {
  const factory HomeFeed({
    /// The promoted title. Null when the catalogue is empty.
    required Content? featured,
    required List<ContentSection> sections,
  }) = _HomeFeed;

  const HomeFeed._();

  /// Rails with nothing in them are dropped rather than rendered as gaps.
  List<ContentSection> get visibleSections =>
      sections.where((section) => !section.isEmpty).toList();

  bool get isEmpty => featured == null && visibleSections.isEmpty;
}
