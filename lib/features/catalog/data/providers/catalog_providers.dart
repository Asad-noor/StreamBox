import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:streambox/features/catalog/data/datasources/content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/datasources/fake_content_remote_data_source.dart';
import 'package:streambox/features/catalog/data/repositories/content_repository_impl.dart';
import 'package:streambox/features/catalog/domain/repositories/content_repository.dart';

part 'catalog_providers.g.dart';

/// Where catalogue data comes from.
///
/// Currently the in-memory fake. Pointing this at a Dio-backed implementation
/// is the single change required to move the whole application onto a real
/// backend — nothing above the data layer references this type.
@Riverpod(keepAlive: true)
ContentRemoteDataSource contentRemoteDataSource(Ref ref) =>
    const FakeContentRemoteDataSource();

/// The repository is kept alive: its in-memory feed cache is the reason
/// returning to the home tab does not re-issue a request.
@Riverpod(keepAlive: true)
ContentRepository contentRepository(Ref ref) => ContentRepositoryImpl(
  remoteDataSource: ref.watch(contentRemoteDataSourceProvider),
);
