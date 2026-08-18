// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_history_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WatchHistoryEntry {

 ContentSnapshot get content; PlaybackProgress get progress;
/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchHistoryEntryCopyWith<WatchHistoryEntry> get copyWith => _$WatchHistoryEntryCopyWithImpl<WatchHistoryEntry>(this as WatchHistoryEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchHistoryEntry&&(identical(other.content, content) || other.content == content)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,content,progress);

@override
String toString() {
  return 'WatchHistoryEntry(content: $content, progress: $progress)';
}


}

/// @nodoc
abstract mixin class $WatchHistoryEntryCopyWith<$Res>  {
  factory $WatchHistoryEntryCopyWith(WatchHistoryEntry value, $Res Function(WatchHistoryEntry) _then) = _$WatchHistoryEntryCopyWithImpl;
@useResult
$Res call({
 ContentSnapshot content, PlaybackProgress progress
});


$ContentSnapshotCopyWith<$Res> get content;$PlaybackProgressCopyWith<$Res> get progress;

}
/// @nodoc
class _$WatchHistoryEntryCopyWithImpl<$Res>
    implements $WatchHistoryEntryCopyWith<$Res> {
  _$WatchHistoryEntryCopyWithImpl(this._self, this._then);

  final WatchHistoryEntry _self;
  final $Res Function(WatchHistoryEntry) _then;

/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? progress = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentSnapshot,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as PlaybackProgress,
  ));
}
/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<$Res> get content {
  
  return $ContentSnapshotCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaybackProgressCopyWith<$Res> get progress {
  
  return $PlaybackProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}


/// Adds pattern-matching-related methods to [WatchHistoryEntry].
extension WatchHistoryEntryPatterns on WatchHistoryEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchHistoryEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchHistoryEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchHistoryEntry value)  $default,){
final _that = this;
switch (_that) {
case _WatchHistoryEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchHistoryEntry value)?  $default,){
final _that = this;
switch (_that) {
case _WatchHistoryEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContentSnapshot content,  PlaybackProgress progress)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchHistoryEntry() when $default != null:
return $default(_that.content,_that.progress);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContentSnapshot content,  PlaybackProgress progress)  $default,) {final _that = this;
switch (_that) {
case _WatchHistoryEntry():
return $default(_that.content,_that.progress);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContentSnapshot content,  PlaybackProgress progress)?  $default,) {final _that = this;
switch (_that) {
case _WatchHistoryEntry() when $default != null:
return $default(_that.content,_that.progress);case _:
  return null;

}
}

}

/// @nodoc


class _WatchHistoryEntry extends WatchHistoryEntry {
  const _WatchHistoryEntry({required this.content, required this.progress}): super._();
  

@override final  ContentSnapshot content;
@override final  PlaybackProgress progress;

/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchHistoryEntryCopyWith<_WatchHistoryEntry> get copyWith => __$WatchHistoryEntryCopyWithImpl<_WatchHistoryEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchHistoryEntry&&(identical(other.content, content) || other.content == content)&&(identical(other.progress, progress) || other.progress == progress));
}


@override
int get hashCode => Object.hash(runtimeType,content,progress);

@override
String toString() {
  return 'WatchHistoryEntry(content: $content, progress: $progress)';
}


}

/// @nodoc
abstract mixin class _$WatchHistoryEntryCopyWith<$Res> implements $WatchHistoryEntryCopyWith<$Res> {
  factory _$WatchHistoryEntryCopyWith(_WatchHistoryEntry value, $Res Function(_WatchHistoryEntry) _then) = __$WatchHistoryEntryCopyWithImpl;
@override @useResult
$Res call({
 ContentSnapshot content, PlaybackProgress progress
});


@override $ContentSnapshotCopyWith<$Res> get content;@override $PlaybackProgressCopyWith<$Res> get progress;

}
/// @nodoc
class __$WatchHistoryEntryCopyWithImpl<$Res>
    implements _$WatchHistoryEntryCopyWith<$Res> {
  __$WatchHistoryEntryCopyWithImpl(this._self, this._then);

  final _WatchHistoryEntry _self;
  final $Res Function(_WatchHistoryEntry) _then;

/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? progress = null,}) {
  return _then(_WatchHistoryEntry(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentSnapshot,progress: null == progress ? _self.progress : progress // ignore: cast_nullable_to_non_nullable
as PlaybackProgress,
  ));
}

/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<$Res> get content {
  
  return $ContentSnapshotCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}/// Create a copy of WatchHistoryEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaybackProgressCopyWith<$Res> get progress {
  
  return $PlaybackProgressCopyWith<$Res>(_self.progress, (value) {
    return _then(_self.copyWith(progress: value));
  });
}
}

// dart format on
