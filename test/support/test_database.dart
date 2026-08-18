import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart' show Override;
import 'package:streambox/core/database/app_database.dart';
import 'package:streambox/core/database/database_provider.dart';
import 'package:streambox/features/catalog/data/datasources/fake_content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/providers/catalog_providers.dart';
import 'package:streambox/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:streambox/features/player/presentation/providers/player_providers.dart';

import 'fake_favorites_repository.dart';
import 'recording_playback_progress_repository.dart';

/// A fresh in-memory database, closed when the test ends.
///
/// Tests run against real SQLite rather than a hand-written stand-in, so the
/// SQL, the schema and Drift's change notifications are all genuinely
/// exercised — while staying isolated and leaving nothing on disk.
AppDatabase createTestDatabase() {
  // Several isolated databases legitimately coexist within one test file, each
  // with its own executor, so drift's shared-executor warning is noise here.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  final database = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(database.close);

  return database;
}

/// Overrides shared by tests that boot the whole application.
///
/// The persistence repositories are replaced with in-memory fakes rather than
/// pointed at a test database: drift runs its queries on the real event loop,
/// which a widget test's fake clock never advances, so a screen reading live
/// SQLite would sit on its skeleton forever. The drift implementations have
/// their own tests against real SQLite.
///
/// The database provider is still overridden so that nothing can accidentally
/// open the file-backed connection.
List<Override> testOverrides() => [
  appDatabaseProvider.overrideWithValue(createTestDatabase()),
  contentRemoteDataSourceProvider.overrideWithValue(
    const FakeContentRemoteDataSource(latency: Duration.zero),
  ),
  favoritesRepositoryProvider.overrideWithValue(_disposedAfterTest()),
  playbackProgressRepositoryProvider.overrideWithValue(
    _progressRepositoryForTest(),
  ),
];

FakeFavoritesRepository _disposedAfterTest() {
  final repository = FakeFavoritesRepository();
  addTearDown(repository.dispose);

  return repository;
}

RecordingPlaybackProgressRepository _progressRepositoryForTest() {
  final repository = RecordingPlaybackProgressRepository();
  addTearDown(repository.dispose);

  return repository;
}
