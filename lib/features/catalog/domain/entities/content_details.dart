import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/episode.dart';
import 'package:streambox/features/catalog/domain/entities/season.dart';

part 'content_details.freezed.dart';

/// The full record for one title.
///
/// Deliberately distinct from [Content]: rails and search results carry the
/// summary, and only the details screen pays for seasons and episodes. Keeping
/// them apart means `seasons` is never ambiguous between "not loaded",
/// "this is a movie" and "genuinely empty" — a movie simply has none.
@freezed
abstract class ContentDetails with _$ContentDetails {
  const factory ContentDetails({
    required Content content,

    /// Always empty for a movie.
    @Default(<Season>[]) List<Season> seasons,
  }) = _ContentDetails;

  const ContentDetails._();

  String get id => content.id;

  String get title => content.title;

  bool get isSeries => content.isSeries;

  bool get hasSeasons => seasons.isNotEmpty;

  /// What the Watch button plays.
  ///
  /// A movie plays its own stream; a series starts at the first episode of its
  /// earliest season, which is what a viewer with no history expects.
  String? get primaryStreamUrl {
    if (!isSeries) return content.streamUrl;

    for (final season in seasons) {
      final episode = season.firstEpisode;
      if (episode?.isPlayable ?? false) return episode!.streamUrl;
    }

    return null;
  }

  bool get isPlayable => primaryStreamUrl != null;

  /// The episode the Watch button starts on, or null for a movie.
  Episode? get firstEpisode {
    if (!isSeries) return null;

    for (final season in seasons) {
      if (season.firstEpisode case final episode?) return episode;
    }

    return null;
  }

  /// `3 seasons` / `1 season`, or the runtime for a movie.
  String get lengthLabel {
    if (!isSeries) return content.formattedDuration;

    final count = seasons.length;
    return count == 1 ? '1 season' : '$count seasons';
  }
}
