import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/episode.dart';

part 'season.freezed.dart';

/// One season of a series, with its episodes.
@freezed
abstract class Season with _$Season {
  const factory Season({
    required int number,
    required String title,
    required List<Episode> episodes,
  }) = _Season;

  const Season._();

  int get episodeCount => episodes.length;

  bool get isEmpty => episodes.isEmpty;

  /// The episode a viewer should be offered first. Null for an empty season.
  Episode? get firstEpisode => episodes.firstOrNull;
}
