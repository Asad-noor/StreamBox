import 'dart:async';

import 'package:streambox/core/error/app_exception.dart';
import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/catalog/domain/entities/content.dart';
import 'package:streambox/features/catalog/domain/entities/content_snapshot.dart';
import 'package:streambox/features/favorites/domain/entities/favorite_entry.dart';
import 'package:streambox/features/favorites/domain/repositories/favorites_repository.dart';

/// An in-memory [FavoritesRepository] for widget tests.
///
/// Screens are tested against this rather than a real database: drift runs its
/// queries on the real event loop, which a widget test's fake clock never
/// advances, so a screen reading live SQLite would sit on its skeleton
/// forever. The drift implementation has its own tests against real SQLite.
final class FakeFavoritesRepository implements FavoritesRepository {
  FakeFavoritesRepository({DateTime? now})
    : _now = now ?? DateTime(2026, 8, 19, 12);

  final DateTime _now;
  final Map<String, FavoriteEntry> _entries = {};
  final StreamController<List<FavoriteEntry>> _controller =
      StreamController<List<FavoriteEntry>>.broadcast();

  /// When set, writes fail with this.
  AppException? failure;

  List<FavoriteEntry> get _snapshot =>
      _entries.values.toList()..sort((a, b) => b.addedAt.compareTo(a.addedAt));

  @override
  Stream<List<FavoriteEntry>> watchFavorites() => _emitCurrentThen(_snapshot);

  @override
  Stream<Set<String>> watchFavoriteIds() => watchFavorites().map(
    (entries) => entries.map((e) => e.contentId).toSet(),
  );

  @override
  Future<Result<Set<String>>> getFavoriteIds() async =>
      Success(_entries.keys.toSet());

  @override
  Future<Result<void>> add(Content content) async {
    if (failure case final failure?) return Failure(failure);

    _entries[content.id] = FavoriteEntry(
      content: ContentSnapshot.fromContent(content),
      addedAt: _now,
    );
    _emit();

    return const Success(null);
  }

  @override
  Future<Result<void>> remove(String contentId) async {
    if (failure case final failure?) return Failure(failure);

    _entries.remove(contentId);
    _emit();

    return const Success(null);
  }

  Future<void> dispose() => _controller.close();

  /// Delivers the current value and the subscription in one synchronous turn,
  /// so no change can slip through the gap.
  Stream<List<FavoriteEntry>> _emitCurrentThen(List<FavoriteEntry> current) =>
      Stream.multi((controller) {
        controller.add(current);

        final subscription = _controller.stream.listen(
          controller.add,
          onError: controller.addError,
          onDone: controller.close,
        );

        controller.onCancel = subscription.cancel;
      });

  void _emit() {
    if (!_controller.isClosed) _controller.add(_snapshot);
  }
}
