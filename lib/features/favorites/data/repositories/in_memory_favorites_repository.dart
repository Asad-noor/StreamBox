import 'dart:async';

import 'package:streambox/core/result/result.dart';
import 'package:streambox/features/favorites/domain/repositories/favorites_repository.dart';

/// Holds favourites for the lifetime of the process.
///
/// A deliberate placeholder: phase 7 replaces it with a database-backed
/// implementation. It exists so the details and favourites screens can be
/// built and tested against the real contract now, rather than against a
/// half-feature that has to be revisited.
final class InMemoryFavoritesRepository implements FavoritesRepository {
  InMemoryFavoritesRepository({Set<String>? initialIds})
    : _ids = {...?initialIds};

  final Set<String> _ids;
  final StreamController<Set<String>> _controller =
      StreamController<Set<String>>.broadcast();

  @override
  Stream<Set<String>> watchFavoriteIds() => Stream.multi((controller) {
    // The current value and the subscription must be established in the same
    // synchronous turn. An `async*` generator yields the snapshot and only
    // then subscribes, and any change landing in that gap is lost because the
    // underlying stream is a broadcast.
    controller.add(_snapshot);

    final subscription = _controller.stream.listen(
      controller.add,
      onError: controller.addError,
      onDone: controller.close,
    );

    controller.onCancel = subscription.cancel;
  });

  @override
  Future<Result<Set<String>>> getFavoriteIds() async => Success(_snapshot);

  @override
  Future<Result<void>> add(String contentId) async {
    if (_ids.add(contentId)) _emit();

    return const Success(null);
  }

  @override
  Future<Result<void>> remove(String contentId) async {
    if (_ids.remove(contentId)) _emit();

    return const Success(null);
  }

  /// Closes the change stream. Wired to provider disposal.
  Future<void> dispose() => _controller.close();

  /// An unmodifiable copy: handing out the live set would let callers mutate
  /// the store without going through [add] or [remove].
  Set<String> get _snapshot => Set.unmodifiable(_ids);

  void _emit() {
    if (!_controller.isClosed) _controller.add(_snapshot);
  }
}
