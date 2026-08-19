// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playable.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Playable {

 String get id; String get title; String get streamUrl;/// What watch history stores. For an episode this carries the series
/// artwork, so history shows something recognisable.
 ContentSnapshot get snapshot;
/// Create a copy of Playable
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayableCopyWith<Playable> get copyWith => _$PlayableCopyWithImpl<Playable>(this as Playable, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Playable&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,streamUrl,snapshot);

@override
String toString() {
  return 'Playable(id: $id, title: $title, streamUrl: $streamUrl, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class $PlayableCopyWith<$Res>  {
  factory $PlayableCopyWith(Playable value, $Res Function(Playable) _then) = _$PlayableCopyWithImpl;
@useResult
$Res call({
 String id, String title, String streamUrl, ContentSnapshot snapshot
});


$ContentSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class _$PlayableCopyWithImpl<$Res>
    implements $PlayableCopyWith<$Res> {
  _$PlayableCopyWithImpl(this._self, this._then);

  final Playable _self;
  final $Res Function(Playable) _then;

/// Create a copy of Playable
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? streamUrl = null,Object? snapshot = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ContentSnapshot,
  ));
}
/// Create a copy of Playable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<$Res> get snapshot {
  
  return $ContentSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [Playable].
extension PlayablePatterns on Playable {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Playable value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Playable() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Playable value)  $default,){
final _that = this;
switch (_that) {
case _Playable():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Playable value)?  $default,){
final _that = this;
switch (_that) {
case _Playable() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String streamUrl,  ContentSnapshot snapshot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Playable() when $default != null:
return $default(_that.id,_that.title,_that.streamUrl,_that.snapshot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String streamUrl,  ContentSnapshot snapshot)  $default,) {final _that = this;
switch (_that) {
case _Playable():
return $default(_that.id,_that.title,_that.streamUrl,_that.snapshot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String streamUrl,  ContentSnapshot snapshot)?  $default,) {final _that = this;
switch (_that) {
case _Playable() when $default != null:
return $default(_that.id,_that.title,_that.streamUrl,_that.snapshot);case _:
  return null;

}
}

}

/// @nodoc


class _Playable extends Playable {
  const _Playable({required this.id, required this.title, required this.streamUrl, required this.snapshot}): super._();
  

@override final  String id;
@override final  String title;
@override final  String streamUrl;
/// What watch history stores. For an episode this carries the series
/// artwork, so history shows something recognisable.
@override final  ContentSnapshot snapshot;

/// Create a copy of Playable
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayableCopyWith<_Playable> get copyWith => __$PlayableCopyWithImpl<_Playable>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Playable&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.snapshot, snapshot) || other.snapshot == snapshot));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,streamUrl,snapshot);

@override
String toString() {
  return 'Playable(id: $id, title: $title, streamUrl: $streamUrl, snapshot: $snapshot)';
}


}

/// @nodoc
abstract mixin class _$PlayableCopyWith<$Res> implements $PlayableCopyWith<$Res> {
  factory _$PlayableCopyWith(_Playable value, $Res Function(_Playable) _then) = __$PlayableCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String streamUrl, ContentSnapshot snapshot
});


@override $ContentSnapshotCopyWith<$Res> get snapshot;

}
/// @nodoc
class __$PlayableCopyWithImpl<$Res>
    implements _$PlayableCopyWith<$Res> {
  __$PlayableCopyWithImpl(this._self, this._then);

  final _Playable _self;
  final $Res Function(_Playable) _then;

/// Create a copy of Playable
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? streamUrl = null,Object? snapshot = null,}) {
  return _then(_Playable(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,streamUrl: null == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as ContentSnapshot,
  ));
}

/// Create a copy of Playable
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentSnapshotCopyWith<$Res> get snapshot {
  
  return $ContentSnapshotCopyWith<$Res>(_self.snapshot, (value) {
    return _then(_self.copyWith(snapshot: value));
  });
}
}

// dart format on
