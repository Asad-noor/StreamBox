import 'package:streambox/core/result/result.dart';

/// Which titles the viewer has saved.
///
/// Backed by an in-memory store today and by the local database in phase 7.
/// Because the contract is expressed here, that swap is a provider change and
/// nothing in the presentation layer moves.
abstract interface class FavoritesRepository {
  /// Emits the full set of saved identifiers, and again on every change.
  ///
  /// A stream rather than a future so that a title favourited on the details
  /// screen is reflected on the favourites tab without either screen knowing
  /// the other exists.
  Stream<Set<String>> watchFavoriteIds();

  Future<Result<Set<String>>> getFavoriteIds();

  Future<Result<void>> add(String contentId);

  Future<Result<void>> remove(String contentId);
}
