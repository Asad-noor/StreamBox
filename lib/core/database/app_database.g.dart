// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FavoriteEntriesTable extends FavoriteEntries
    with TableInfo<$FavoriteEntriesTable, FavoriteEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta(
    'releaseYear',
  );
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    title,
    posterUrl,
    releaseYear,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_posterUrlMeta);
    }
    if (data.containsKey('release_year')) {
      context.handle(
        _releaseYearMeta,
        releaseYear.isAcceptableOrUnknown(
          data['release_year']!,
          _releaseYearMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_releaseYearMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  FavoriteEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteEntryRow(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      )!,
      releaseYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_year'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoriteEntriesTable createAlias(String alias) {
    return $FavoriteEntriesTable(attachedDatabase, alias);
  }
}

class FavoriteEntryRow extends DataClass
    implements Insertable<FavoriteEntryRow> {
  final String contentId;
  final String title;
  final String posterUrl;
  final int releaseYear;
  final DateTime addedAt;
  const FavoriteEntryRow({
    required this.contentId,
    required this.title,
    required this.posterUrl,
    required this.releaseYear,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['title'] = Variable<String>(title);
    map['poster_url'] = Variable<String>(posterUrl);
    map['release_year'] = Variable<int>(releaseYear);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoriteEntriesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteEntriesCompanion(
      contentId: Value(contentId),
      title: Value(title),
      posterUrl: Value(posterUrl),
      releaseYear: Value(releaseYear),
      addedAt: Value(addedAt),
    );
  }

  factory FavoriteEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteEntryRow(
      contentId: serializer.fromJson<String>(json['contentId']),
      title: serializer.fromJson<String>(json['title']),
      posterUrl: serializer.fromJson<String>(json['posterUrl']),
      releaseYear: serializer.fromJson<int>(json['releaseYear']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'title': serializer.toJson<String>(title),
      'posterUrl': serializer.toJson<String>(posterUrl),
      'releaseYear': serializer.toJson<int>(releaseYear),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  FavoriteEntryRow copyWith({
    String? contentId,
    String? title,
    String? posterUrl,
    int? releaseYear,
    DateTime? addedAt,
  }) => FavoriteEntryRow(
    contentId: contentId ?? this.contentId,
    title: title ?? this.title,
    posterUrl: posterUrl ?? this.posterUrl,
    releaseYear: releaseYear ?? this.releaseYear,
    addedAt: addedAt ?? this.addedAt,
  );
  FavoriteEntryRow copyWithCompanion(FavoriteEntriesCompanion data) {
    return FavoriteEntryRow(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      title: data.title.present ? data.title.value : this.title,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
      releaseYear: data.releaseYear.present
          ? data.releaseYear.value
          : this.releaseYear,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteEntryRow(')
          ..write('contentId: $contentId, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(contentId, title, posterUrl, releaseYear, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteEntryRow &&
          other.contentId == this.contentId &&
          other.title == this.title &&
          other.posterUrl == this.posterUrl &&
          other.releaseYear == this.releaseYear &&
          other.addedAt == this.addedAt);
}

class FavoriteEntriesCompanion extends UpdateCompanion<FavoriteEntryRow> {
  final Value<String> contentId;
  final Value<String> title;
  final Value<String> posterUrl;
  final Value<int> releaseYear;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const FavoriteEntriesCompanion({
    this.contentId = const Value.absent(),
    this.title = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteEntriesCompanion.insert({
    required String contentId,
    required String title,
    required String posterUrl,
    required int releaseYear,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       title = Value(title),
       posterUrl = Value(posterUrl),
       releaseYear = Value(releaseYear),
       addedAt = Value(addedAt);
  static Insertable<FavoriteEntryRow> custom({
    Expression<String>? contentId,
    Expression<String>? title,
    Expression<String>? posterUrl,
    Expression<int>? releaseYear,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (title != null) 'title': title,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (releaseYear != null) 'release_year': releaseYear,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteEntriesCompanion copyWith({
    Value<String>? contentId,
    Value<String>? title,
    Value<String>? posterUrl,
    Value<int>? releaseYear,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return FavoriteEntriesCompanion(
      contentId: contentId ?? this.contentId,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      releaseYear: releaseYear ?? this.releaseYear,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteEntriesCompanion(')
          ..write('contentId: $contentId, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlaybackProgressEntriesTable extends PlaybackProgressEntries
    with TableInfo<$PlaybackProgressEntriesTable, PlaybackProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlaybackProgressEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _contentIdMeta = const VerificationMeta(
    'contentId',
  );
  @override
  late final GeneratedColumn<String> contentId = GeneratedColumn<String>(
    'content_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMsMeta = const VerificationMeta(
    'positionMs',
  );
  @override
  late final GeneratedColumn<int> positionMs = GeneratedColumn<int>(
    'position_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posterUrlMeta = const VerificationMeta(
    'posterUrl',
  );
  @override
  late final GeneratedColumn<String> posterUrl = GeneratedColumn<String>(
    'poster_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _releaseYearMeta = const VerificationMeta(
    'releaseYear',
  );
  @override
  late final GeneratedColumn<int> releaseYear = GeneratedColumn<int>(
    'release_year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    contentId,
    positionMs,
    durationMs,
    title,
    posterUrl,
    releaseYear,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'playback_progress_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlaybackProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('content_id')) {
      context.handle(
        _contentIdMeta,
        contentId.isAcceptableOrUnknown(data['content_id']!, _contentIdMeta),
      );
    } else if (isInserting) {
      context.missing(_contentIdMeta);
    }
    if (data.containsKey('position_ms')) {
      context.handle(
        _positionMsMeta,
        positionMs.isAcceptableOrUnknown(data['position_ms']!, _positionMsMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMsMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('poster_url')) {
      context.handle(
        _posterUrlMeta,
        posterUrl.isAcceptableOrUnknown(data['poster_url']!, _posterUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_posterUrlMeta);
    }
    if (data.containsKey('release_year')) {
      context.handle(
        _releaseYearMeta,
        releaseYear.isAcceptableOrUnknown(
          data['release_year']!,
          _releaseYearMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_releaseYearMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {contentId};
  @override
  PlaybackProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlaybackProgressRow(
      contentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_id'],
      )!,
      positionMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_ms'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      posterUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}poster_url'],
      )!,
      releaseYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}release_year'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PlaybackProgressEntriesTable createAlias(String alias) {
    return $PlaybackProgressEntriesTable(attachedDatabase, alias);
  }
}

class PlaybackProgressRow extends DataClass
    implements Insertable<PlaybackProgressRow> {
  final String contentId;
  final int positionMs;
  final int durationMs;
  final String title;
  final String posterUrl;
  final int releaseYear;
  final DateTime updatedAt;
  const PlaybackProgressRow({
    required this.contentId,
    required this.positionMs,
    required this.durationMs,
    required this.title,
    required this.posterUrl,
    required this.releaseYear,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['content_id'] = Variable<String>(contentId);
    map['position_ms'] = Variable<int>(positionMs);
    map['duration_ms'] = Variable<int>(durationMs);
    map['title'] = Variable<String>(title);
    map['poster_url'] = Variable<String>(posterUrl);
    map['release_year'] = Variable<int>(releaseYear);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PlaybackProgressEntriesCompanion toCompanion(bool nullToAbsent) {
    return PlaybackProgressEntriesCompanion(
      contentId: Value(contentId),
      positionMs: Value(positionMs),
      durationMs: Value(durationMs),
      title: Value(title),
      posterUrl: Value(posterUrl),
      releaseYear: Value(releaseYear),
      updatedAt: Value(updatedAt),
    );
  }

  factory PlaybackProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlaybackProgressRow(
      contentId: serializer.fromJson<String>(json['contentId']),
      positionMs: serializer.fromJson<int>(json['positionMs']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      title: serializer.fromJson<String>(json['title']),
      posterUrl: serializer.fromJson<String>(json['posterUrl']),
      releaseYear: serializer.fromJson<int>(json['releaseYear']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'contentId': serializer.toJson<String>(contentId),
      'positionMs': serializer.toJson<int>(positionMs),
      'durationMs': serializer.toJson<int>(durationMs),
      'title': serializer.toJson<String>(title),
      'posterUrl': serializer.toJson<String>(posterUrl),
      'releaseYear': serializer.toJson<int>(releaseYear),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PlaybackProgressRow copyWith({
    String? contentId,
    int? positionMs,
    int? durationMs,
    String? title,
    String? posterUrl,
    int? releaseYear,
    DateTime? updatedAt,
  }) => PlaybackProgressRow(
    contentId: contentId ?? this.contentId,
    positionMs: positionMs ?? this.positionMs,
    durationMs: durationMs ?? this.durationMs,
    title: title ?? this.title,
    posterUrl: posterUrl ?? this.posterUrl,
    releaseYear: releaseYear ?? this.releaseYear,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PlaybackProgressRow copyWithCompanion(PlaybackProgressEntriesCompanion data) {
    return PlaybackProgressRow(
      contentId: data.contentId.present ? data.contentId.value : this.contentId,
      positionMs: data.positionMs.present
          ? data.positionMs.value
          : this.positionMs,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      title: data.title.present ? data.title.value : this.title,
      posterUrl: data.posterUrl.present ? data.posterUrl.value : this.posterUrl,
      releaseYear: data.releaseYear.present
          ? data.releaseYear.value
          : this.releaseYear,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressRow(')
          ..write('contentId: $contentId, ')
          ..write('positionMs: $positionMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    contentId,
    positionMs,
    durationMs,
    title,
    posterUrl,
    releaseYear,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlaybackProgressRow &&
          other.contentId == this.contentId &&
          other.positionMs == this.positionMs &&
          other.durationMs == this.durationMs &&
          other.title == this.title &&
          other.posterUrl == this.posterUrl &&
          other.releaseYear == this.releaseYear &&
          other.updatedAt == this.updatedAt);
}

class PlaybackProgressEntriesCompanion
    extends UpdateCompanion<PlaybackProgressRow> {
  final Value<String> contentId;
  final Value<int> positionMs;
  final Value<int> durationMs;
  final Value<String> title;
  final Value<String> posterUrl;
  final Value<int> releaseYear;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PlaybackProgressEntriesCompanion({
    this.contentId = const Value.absent(),
    this.positionMs = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.title = const Value.absent(),
    this.posterUrl = const Value.absent(),
    this.releaseYear = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlaybackProgressEntriesCompanion.insert({
    required String contentId,
    required int positionMs,
    required int durationMs,
    required String title,
    required String posterUrl,
    required int releaseYear,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : contentId = Value(contentId),
       positionMs = Value(positionMs),
       durationMs = Value(durationMs),
       title = Value(title),
       posterUrl = Value(posterUrl),
       releaseYear = Value(releaseYear),
       updatedAt = Value(updatedAt);
  static Insertable<PlaybackProgressRow> custom({
    Expression<String>? contentId,
    Expression<int>? positionMs,
    Expression<int>? durationMs,
    Expression<String>? title,
    Expression<String>? posterUrl,
    Expression<int>? releaseYear,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (contentId != null) 'content_id': contentId,
      if (positionMs != null) 'position_ms': positionMs,
      if (durationMs != null) 'duration_ms': durationMs,
      if (title != null) 'title': title,
      if (posterUrl != null) 'poster_url': posterUrl,
      if (releaseYear != null) 'release_year': releaseYear,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlaybackProgressEntriesCompanion copyWith({
    Value<String>? contentId,
    Value<int>? positionMs,
    Value<int>? durationMs,
    Value<String>? title,
    Value<String>? posterUrl,
    Value<int>? releaseYear,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PlaybackProgressEntriesCompanion(
      contentId: contentId ?? this.contentId,
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      title: title ?? this.title,
      posterUrl: posterUrl ?? this.posterUrl,
      releaseYear: releaseYear ?? this.releaseYear,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (contentId.present) {
      map['content_id'] = Variable<String>(contentId.value);
    }
    if (positionMs.present) {
      map['position_ms'] = Variable<int>(positionMs.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (posterUrl.present) {
      map['poster_url'] = Variable<String>(posterUrl.value);
    }
    if (releaseYear.present) {
      map['release_year'] = Variable<int>(releaseYear.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlaybackProgressEntriesCompanion(')
          ..write('contentId: $contentId, ')
          ..write('positionMs: $positionMs, ')
          ..write('durationMs: $durationMs, ')
          ..write('title: $title, ')
          ..write('posterUrl: $posterUrl, ')
          ..write('releaseYear: $releaseYear, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteEntriesTable favoriteEntries = $FavoriteEntriesTable(
    this,
  );
  late final $PlaybackProgressEntriesTable playbackProgressEntries =
      $PlaybackProgressEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    favoriteEntries,
    playbackProgressEntries,
  ];
}

typedef $$FavoriteEntriesTableCreateCompanionBuilder =
    FavoriteEntriesCompanion Function({
      required String contentId,
      required String title,
      required String posterUrl,
      required int releaseYear,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$FavoriteEntriesTableUpdateCompanionBuilder =
    FavoriteEntriesCompanion Function({
      Value<String> contentId,
      Value<String> title,
      Value<String> posterUrl,
      Value<int> releaseYear,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$FavoriteEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteEntriesTable> {
  $$FavoriteEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoriteEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteEntriesTable> {
  $$FavoriteEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoriteEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteEntriesTable> {
  $$FavoriteEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);

  GeneratedColumn<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoriteEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteEntriesTable,
          FavoriteEntryRow,
          $$FavoriteEntriesTableFilterComposer,
          $$FavoriteEntriesTableOrderingComposer,
          $$FavoriteEntriesTableAnnotationComposer,
          $$FavoriteEntriesTableCreateCompanionBuilder,
          $$FavoriteEntriesTableUpdateCompanionBuilder,
          (
            FavoriteEntryRow,
            BaseReferences<
              _$AppDatabase,
              $FavoriteEntriesTable,
              FavoriteEntryRow
            >,
          ),
          FavoriteEntryRow,
          PrefetchHooks Function()
        > {
  $$FavoriteEntriesTableTableManager(
    _$AppDatabase db,
    $FavoriteEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> posterUrl = const Value.absent(),
                Value<int> releaseYear = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteEntriesCompanion(
                contentId: contentId,
                title: title,
                posterUrl: posterUrl,
                releaseYear: releaseYear,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required String title,
                required String posterUrl,
                required int releaseYear,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => FavoriteEntriesCompanion.insert(
                contentId: contentId,
                title: title,
                posterUrl: posterUrl,
                releaseYear: releaseYear,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteEntriesTable,
      FavoriteEntryRow,
      $$FavoriteEntriesTableFilterComposer,
      $$FavoriteEntriesTableOrderingComposer,
      $$FavoriteEntriesTableAnnotationComposer,
      $$FavoriteEntriesTableCreateCompanionBuilder,
      $$FavoriteEntriesTableUpdateCompanionBuilder,
      (
        FavoriteEntryRow,
        BaseReferences<_$AppDatabase, $FavoriteEntriesTable, FavoriteEntryRow>,
      ),
      FavoriteEntryRow,
      PrefetchHooks Function()
    >;
typedef $$PlaybackProgressEntriesTableCreateCompanionBuilder =
    PlaybackProgressEntriesCompanion Function({
      required String contentId,
      required int positionMs,
      required int durationMs,
      required String title,
      required String posterUrl,
      required int releaseYear,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PlaybackProgressEntriesTableUpdateCompanionBuilder =
    PlaybackProgressEntriesCompanion Function({
      Value<String> contentId,
      Value<int> positionMs,
      Value<int> durationMs,
      Value<String> title,
      Value<String> posterUrl,
      Value<int> releaseYear,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PlaybackProgressEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $PlaybackProgressEntriesTable> {
  $$PlaybackProgressEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PlaybackProgressEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlaybackProgressEntriesTable> {
  $$PlaybackProgressEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get contentId => $composableBuilder(
    column: $table.contentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get posterUrl => $composableBuilder(
    column: $table.posterUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PlaybackProgressEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlaybackProgressEntriesTable> {
  $$PlaybackProgressEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get contentId =>
      $composableBuilder(column: $table.contentId, builder: (column) => column);

  GeneratedColumn<int> get positionMs => $composableBuilder(
    column: $table.positionMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get posterUrl =>
      $composableBuilder(column: $table.posterUrl, builder: (column) => column);

  GeneratedColumn<int> get releaseYear => $composableBuilder(
    column: $table.releaseYear,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PlaybackProgressEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlaybackProgressEntriesTable,
          PlaybackProgressRow,
          $$PlaybackProgressEntriesTableFilterComposer,
          $$PlaybackProgressEntriesTableOrderingComposer,
          $$PlaybackProgressEntriesTableAnnotationComposer,
          $$PlaybackProgressEntriesTableCreateCompanionBuilder,
          $$PlaybackProgressEntriesTableUpdateCompanionBuilder,
          (
            PlaybackProgressRow,
            BaseReferences<
              _$AppDatabase,
              $PlaybackProgressEntriesTable,
              PlaybackProgressRow
            >,
          ),
          PlaybackProgressRow,
          PrefetchHooks Function()
        > {
  $$PlaybackProgressEntriesTableTableManager(
    _$AppDatabase db,
    $PlaybackProgressEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlaybackProgressEntriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$PlaybackProgressEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$PlaybackProgressEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> contentId = const Value.absent(),
                Value<int> positionMs = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> posterUrl = const Value.absent(),
                Value<int> releaseYear = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressEntriesCompanion(
                contentId: contentId,
                positionMs: positionMs,
                durationMs: durationMs,
                title: title,
                posterUrl: posterUrl,
                releaseYear: releaseYear,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String contentId,
                required int positionMs,
                required int durationMs,
                required String title,
                required String posterUrl,
                required int releaseYear,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PlaybackProgressEntriesCompanion.insert(
                contentId: contentId,
                positionMs: positionMs,
                durationMs: durationMs,
                title: title,
                posterUrl: posterUrl,
                releaseYear: releaseYear,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlaybackProgressEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlaybackProgressEntriesTable,
      PlaybackProgressRow,
      $$PlaybackProgressEntriesTableFilterComposer,
      $$PlaybackProgressEntriesTableOrderingComposer,
      $$PlaybackProgressEntriesTableAnnotationComposer,
      $$PlaybackProgressEntriesTableCreateCompanionBuilder,
      $$PlaybackProgressEntriesTableUpdateCompanionBuilder,
      (
        PlaybackProgressRow,
        BaseReferences<
          _$AppDatabase,
          $PlaybackProgressEntriesTable,
          PlaybackProgressRow
        >,
      ),
      PlaybackProgressRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteEntriesTableTableManager get favoriteEntries =>
      $$FavoriteEntriesTableTableManager(_db, _db.favoriteEntries);
  $$PlaybackProgressEntriesTableTableManager get playbackProgressEntries =>
      $$PlaybackProgressEntriesTableTableManager(
        _db,
        _db.playbackProgressEntries,
      );
}
