import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';

part 'favorite_entry.freezed.dart';

/// One saved title.
@freezed
abstract class FavoriteEntry with _$FavoriteEntry {
  const factory FavoriteEntry({
    required ContentSnapshot content,
    required DateTime addedAt,
  }) = _FavoriteEntry;

  const FavoriteEntry._();

  String get contentId => content.contentId;
}
