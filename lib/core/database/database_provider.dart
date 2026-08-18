import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/core/database/app_database.dart';

part 'database_provider.g.dart';

/// The single database connection.
///
/// Kept alive for the process: opening SQLite per screen would be wasteful and
/// would break Drift's change notifications, which are what make the
/// favourites and history screens update reactively.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);

  return database;
}
