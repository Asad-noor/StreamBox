// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FavoriteEntry {

 ContentSnapshot get content; DateTime get addedAt;
/// Create a copy of FavoriteEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FavoriteEntryCopyWith<FavoriteEntry> get copyWith => _$FavoriteEntryCopyWithImpl<FavoriteEntry>(this as FavoriteEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FavoriteEntry&&(identical(other.content, content) || other.content == content)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode => Object.hash(runtimeType,content,addedAt);

@override
String toString() {
  return 'FavoriteEntry(content: $content, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class $FavoriteEntryCopyWith<$Res>  {
  factory $FavoriteEntryCopyWith(FavoriteEntry value, $Res Function(FavoriteEntry) _then) = _$FavoriteEntryCopyWithImpl;
@useResult
$Res call({
 ContentSnapshot content, DateTime addedAt
});


$ContentSnapshotCopyWith<$Res> get content;

}
/// @nodoc
class _$FavoriteEntryCopyWithImpl<$Res>
    implements $FavoriteEntryCopyWith<$Res> {
  _$FavoriteEntryCopyWithImpl(this._self, this._then);

  final FavoriteEntry _self;
  final $Res Function(FavoriteEntry) _then;

/// Create a copy of FavoriteEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? addedAt = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentSnapshot,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of FavoriteEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<$Res> get content {
  
  return $ContentSnapshotCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [FavoriteEntry].
extension FavoriteEntryPatterns on FavoriteEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FavoriteEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FavoriteEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FavoriteEntry value)  $default,){
final _that = this;
switch (_that) {
case _FavoriteEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FavoriteEntry value)?  $default,){
final _that = this;
switch (_that) {
case _FavoriteEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContentSnapshot content,  DateTime addedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FavoriteEntry() when $default != null:
return $default(_that.content,_that.addedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContentSnapshot content,  DateTime addedAt)  $default,) {final _that = this;
switch (_that) {
case _FavoriteEntry():
return $default(_that.content,_that.addedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContentSnapshot content,  DateTime addedAt)?  $default,) {final _that = this;
switch (_that) {
case _FavoriteEntry() when $default != null:
return $default(_that.content,_that.addedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FavoriteEntry extends FavoriteEntry {
  const _FavoriteEntry({required this.content, required this.addedAt}): super._();
  

@override final  ContentSnapshot content;
@override final  DateTime addedAt;

/// Create a copy of FavoriteEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FavoriteEntryCopyWith<_FavoriteEntry> get copyWith => __$FavoriteEntryCopyWithImpl<_FavoriteEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FavoriteEntry&&(identical(other.content, content) || other.content == content)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt));
}


@override
int get hashCode => Object.hash(runtimeType,content,addedAt);

@override
String toString() {
  return 'FavoriteEntry(content: $content, addedAt: $addedAt)';
}


}

/// @nodoc
abstract mixin class _$FavoriteEntryCopyWith<$Res> implements $FavoriteEntryCopyWith<$Res> {
  factory _$FavoriteEntryCopyWith(_FavoriteEntry value, $Res Function(_FavoriteEntry) _then) = __$FavoriteEntryCopyWithImpl;
@override @useResult
$Res call({
 ContentSnapshot content, DateTime addedAt
});


@override $ContentSnapshotCopyWith<$Res> get content;

}
/// @nodoc
class __$FavoriteEntryCopyWithImpl<$Res>
    implements _$FavoriteEntryCopyWith<$Res> {
  __$FavoriteEntryCopyWithImpl(this._self, this._then);

  final _FavoriteEntry _self;
  final $Res Function(_FavoriteEntry) _then;

/// Create a copy of FavoriteEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? addedAt = null,}) {
  return _then(_FavoriteEntry(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as ContentSnapshot,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of FavoriteEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<$Res> get content {
  
  return $ContentSnapshotCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
