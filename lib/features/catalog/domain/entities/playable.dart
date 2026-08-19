import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';

part 'playable.freezed.dart';

/// Something the player can open.
///
/// A movie and an episode are both playable, and the player has no reason to
/// care which it was handed — it needs a stream and enough detail to record
/// what was watched. Resolving an identifier to one of these is the
/// catalogue's job, not the player's.
@freezed
abstract class Playable with _$Playable {
  const factory Playable({
    required String id,
    required String title,
    required String streamUrl,

    /// What watch history stores. For an episode this carries the series
    /// artwork, so history shows something recognisable.
    required ContentSnapshot snapshot,
  }) = _Playable;

  const Playable._();
}
