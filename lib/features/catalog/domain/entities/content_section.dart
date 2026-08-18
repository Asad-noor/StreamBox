import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';

part 'content_section.freezed.dart';

/// Identifies a rail so the UI can treat some of them specially without
/// matching on the display title, which is copy and will change.
enum ContentSectionKind {
  continueWatching,
  trending,
  popular,
  newReleases,
  recommended,
}

/// One horizontal rail of titles.
@freezed
abstract class ContentSection with _$ContentSection {
  const factory ContentSection({
    required ContentSectionKind kind,
    required String title,
    required List<Content> items,
  }) = _ContentSection;

  const ContentSection._();

  bool get isEmpty => items.isEmpty;
}
