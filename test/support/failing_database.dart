import 'package:drift/drift.dart';
import 'package:streambox/core/database/app_database.dart';

/// A database whose every statement fails.
///
/// Exists to prove that driver errors are translated into the application's
/// own error type rather than escaping as raw exceptions — the failure path
/// that a working in-memory database can never reach.
AppDatabase createFailingDatabase() {
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  return AppDatabase.forTesting(_FailingExecutor());
}

class _FailingExecutor extends QueryExecutor {
  @override
  TransactionExecutor beginTransaction() => throw _DriverFailure();

  @override
  Future<bool> ensureOpen(QueryExecutorUser user) async => true;

  @override
  Future<void> runBatched(BatchedStatements statements) =>
      throw _DriverFailure();

  @override
  Future<void> runCustom(String statement, [List<Object?>? args]) =>
      throw _DriverFailure();

  @override
  Future<int> runDelete(String statement, List<Object?> args) =>
      throw _DriverFailure();

  @override
  Future<int> runInsert(String statement, List<Object?> args) =>
      throw _DriverFailure();

  @override
  Future<List<Map<String, Object?>>> runSelect(
    String statement,
    List<Object?> args,
  ) => throw _DriverFailure();

  @override
  Future<int> runUpdate(String statement, List<Object?> args) =>
      throw _DriverFailure();

  @override
  Future<void> close() async {}

  @override
  QueryExecutor beginExclusive() => this;

  @override
  SqlDialect get dialect => SqlDialect.sqlite;
}

class _DriverFailure implements Exception {
  @override
  String toString() => 'simulated driver failure';
}
