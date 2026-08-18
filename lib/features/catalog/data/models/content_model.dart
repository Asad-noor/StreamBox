import 'package:json_annotation/json_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';

part 'content_model.g.dart';

/// The wire format for a title.
///
/// Deliberately separate from [Content]: the API's shape is not ours to
/// choose, and keeping them apart means a backend rename is a change to this
/// file and nothing else. [toEntity] is the only way across the boundary.
@JsonSerializable()
class ContentModel {
  const ContentModel({
    required this.id,
    required this.title,
    required this.type,
    required this.synopsis,
    required this.posterUrl,
    required this.backdropUrl,
    required this.releaseYear,
    required this.genres,
    required this.rating,
    required this.durationMinutes,
    this.streamUrl,
    this.seasonCount,
  });

  factory ContentModel.fromJson(Map<String, dynamic> json) =>
      _$ContentModelFromJson(json);

  final String id;
  final String title;

  /// `movie` or `series`. Anything else falls back to `movie` rather than
  /// failing the whole response over one unrecognised title.
  final String type;

  final String synopsis;

  @JsonKey(name: 'poster_url')
  final String posterUrl;

  @JsonKey(name: 'backdrop_url')
  final String backdropUrl;

  @JsonKey(name: 'release_year')
  final int releaseYear;

  final List<String> genres;
  final double rating;

  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;

  @JsonKey(name: 'stream_url')
  final String? streamUrl;

  @JsonKey(name: 'season_count')
  final int? seasonCount;

  Map<String, dynamic> toJson() => _$ContentModelToJson(this);

  Content toEntity() => Content(
    id: id,
    title: title,
    type: _parseType(type),
    synopsis: synopsis,
    posterUrl: posterUrl,
    backdropUrl: backdropUrl,
    releaseYear: releaseYear,
    genres: genres,
    rating: rating,
    duration: Duration(minutes: durationMinutes),
    streamUrl: streamUrl,
    seasonCount: seasonCount,
  );

  static ContentType _parseType(String value) => switch (value.toLowerCase()) {
    'series' => ContentType.series,
    _ => ContentType.movie,
  };
}
