// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentSnapshot {

 String get contentId; String get title; String get posterUrl; int get releaseYear;
/// Create a copy of ContentSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<ContentSnapshot> get copyWith => _$ContentSnapshotCopyWithImpl<ContentSnapshot>(this as ContentSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentSnapshot&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,title,posterUrl,releaseYear);

@override
String toString() {
  return 'ContentSnapshot(contentId: $contentId, title: $title, posterUrl: $posterUrl, releaseYear: $releaseYear)';
}


}

/// @nodoc
abstract mixin class $ContentSnapshotCopyWith<$Res>  {
  factory $ContentSnapshotCopyWith(ContentSnapshot value, $Res Function(ContentSnapshot) _then) = _$ContentSnapshotCopyWithImpl;
@useResult
$Res call({
 String contentId, String title, String posterUrl, int releaseYear
});




}
/// @nodoc
class _$ContentSnapshotCopyWithImpl<$Res>
    implements $ContentSnapshotCopyWith<$Res> {
  _$ContentSnapshotCopyWithImpl(this._self, this._then);

  final ContentSnapshot _self;
  final $Res Function(ContentSnapshot) _then;

/// Create a copy of ContentSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentId = null,Object? title = null,Object? posterUrl = null,Object? releaseYear = null,}) {
  return _then(_self.copyWith(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterUrl: null == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentSnapshot].
extension ContentSnapshotPatterns on ContentSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ContentSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ContentSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contentId,  String title,  String posterUrl,  int releaseYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentSnapshot() when $default != null:
return $default(_that.contentId,_that.title,_that.posterUrl,_that.releaseYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contentId,  String title,  String posterUrl,  int releaseYear)  $default,) {final _that = this;
switch (_that) {
case _ContentSnapshot():
return $default(_that.contentId,_that.title,_that.posterUrl,_that.releaseYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contentId,  String title,  String posterUrl,  int releaseYear)?  $default,) {final _that = this;
switch (_that) {
case _ContentSnapshot() when $default != null:
return $default(_that.contentId,_that.title,_that.posterUrl,_that.releaseYear);case _:
  return null;

}
}

}

/// @nodoc


class _ContentSnapshot extends ContentSnapshot {
  const _ContentSnapshot({required this.contentId, required this.title, required this.posterUrl, required this.releaseYear}): super._();
  

@override final  String contentId;
@override final  String title;
@override final  String posterUrl;
@override final  int releaseYear;

/// Create a copy of ContentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentSnapshotCopyWith<_ContentSnapshot> get copyWith => __$ContentSnapshotCopyWithImpl<_ContentSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentSnapshot&&(identical(other.contentId, contentId) || other.contentId == contentId)&&(identical(other.title, title) || other.title == title)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear));
}


@override
int get hashCode => Object.hash(runtimeType,contentId,title,posterUrl,releaseYear);

@override
String toString() {
  return 'ContentSnapshot(contentId: $contentId, title: $title, posterUrl: $posterUrl, releaseYear: $releaseYear)';
}


}

/// @nodoc
abstract mixin class _$ContentSnapshotCopyWith<$Res> implements $ContentSnapshotCopyWith<$Res> {
  factory _$ContentSnapshotCopyWith(_ContentSnapshot value, $Res Function(_ContentSnapshot) _then) = __$ContentSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String contentId, String title, String posterUrl, int releaseYear
});




}
/// @nodoc
class __$ContentSnapshotCopyWithImpl<$Res>
    implements _$ContentSnapshotCopyWith<$Res> {
  __$ContentSnapshotCopyWithImpl(this._self, this._then);

  final _ContentSnapshot _self;
  final $Res Function(_ContentSnapshot) _then;

/// Create a copy of ContentSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentId = null,Object? title = null,Object? posterUrl = null,Object? releaseYear = null,}) {
  return _then(_ContentSnapshot(
contentId: null == contentId ? _self.contentId : contentId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,posterUrl: null == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
