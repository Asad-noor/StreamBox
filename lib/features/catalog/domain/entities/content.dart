import 'package:freezed_annotation/freezed_annotation.dart';

part 'content.freezed.dart';

/// What kind of title this is. Drives how the details screen is laid out and
/// whether seasons are meaningful.
enum ContentType { movie, series }

/// A single title in the catalogue.
///
/// This is the shape the presentation layer works with. It has no JSON, no
/// Flutter, and no knowledge of where it came from — mapping from the wire
/// format happens in the data layer.
@freezed
abstract class Content with _$Content {
  const factory Content({
    required String id,
    required String title,
    required ContentType type,
    required String synopsis,
    required String posterUrl,
    required String backdropUrl,
    required int releaseYear,
    required List<String> genres,

    /// Out of 10, as it is conventionally displayed.
    required double rating,

    /// Total runtime for a movie, or of a single episode for a series.
    required Duration duration,

    /// The playable stream. Null while a title is announced but not yet
    /// available, which the UI surfaces by disabling the watch action.
    String? streamUrl,

    /// Series only.
    int? seasonCount,
  }) = _Content;

  const Content._();

  bool get isPlayable => streamUrl != null && streamUrl!.isNotEmpty;

  bool get isSeries => type == ContentType.series;

  /// `1h 52m`, or `52m` when there is no hour component.
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(Duration.minutesPerHour);

    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }

  /// One decimal place, matching how ratings are shown across the app.
  String get formattedRating => rating.toStringAsFixed(1);

  /// The facts shown under a title, in display order.
  List<String> get metadata => [
    '$releaseYear',
    if (genres.isNotEmpty) genres.first,
    formattedDuration,
  ];
}
