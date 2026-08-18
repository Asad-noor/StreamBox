import 'package:freezed_annotation/freezed_annotation.dart';

part 'episode.freezed.dart';

/// One episode of a series.
@freezed
abstract class Episode with _$Episode {
  const factory Episode({
    required String id,
    required int number,
    required String title,
    required String synopsis,
    required String stillUrl,
    required Duration duration,
    String? streamUrl,
  }) = _Episode;

  const Episode._();

  bool get isPlayable => streamUrl != null && streamUrl!.isNotEmpty;

  /// `1h 2m`, or `47m` when there is no hour component.
  String get formattedDuration {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(Duration.minutesPerHour);

    return hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m';
  }
}
