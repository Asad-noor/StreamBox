// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'playback_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PlaybackState {

 PlaybackStatus get status; Duration get position; Duration get duration;/// How far the stream has buffered ahead.
 Duration get buffered; double get speed; bool get isMuted;/// Set only when [status] is [PlaybackStatus.failed].
 AppException? get error;
/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaybackStateCopyWith<PlaybackState> get copyWith => _$PlaybackStateCopyWithImpl<PlaybackState>(this as PlaybackState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlaybackState&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.buffered, buffered) || other.buffered == buffered)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,position,duration,buffered,speed,isMuted,error);

@override
String toString() {
  return 'PlaybackState(status: $status, position: $position, duration: $duration, buffered: $buffered, speed: $speed, isMuted: $isMuted, error: $error)';
}


}

/// @nodoc
abstract mixin class $PlaybackStateCopyWith<$Res>  {
  factory $PlaybackStateCopyWith(PlaybackState value, $Res Function(PlaybackState) _then) = _$PlaybackStateCopyWithImpl;
@useResult
$Res call({
 PlaybackStatus status, Duration position, Duration duration, Duration buffered, double speed, bool isMuted, AppException? error
});




}
/// @nodoc
class _$PlaybackStateCopyWithImpl<$Res>
    implements $PlaybackStateCopyWith<$Res> {
  _$PlaybackStateCopyWithImpl(this._self, this._then);

  final PlaybackState _self;
  final $Res Function(PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? position = null,Object? duration = null,Object? buffered = null,Object? speed = null,Object? isMuted = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,buffered: null == buffered ? _self.buffered : buffered // ignore: cast_nullable_to_non_nullable
as Duration,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlaybackState].
extension PlaybackStatePatterns on PlaybackState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlaybackState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlaybackState value)  $default,){
final _that = this;
switch (_that) {
case _PlaybackState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlaybackState value)?  $default,){
final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PlaybackStatus status,  Duration position,  Duration duration,  Duration buffered,  double speed,  bool isMuted,  AppException? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.status,_that.position,_that.duration,_that.buffered,_that.speed,_that.isMuted,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PlaybackStatus status,  Duration position,  Duration duration,  Duration buffered,  double speed,  bool isMuted,  AppException? error)  $default,) {final _that = this;
switch (_that) {
case _PlaybackState():
return $default(_that.status,_that.position,_that.duration,_that.buffered,_that.speed,_that.isMuted,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PlaybackStatus status,  Duration position,  Duration duration,  Duration buffered,  double speed,  bool isMuted,  AppException? error)?  $default,) {final _that = this;
switch (_that) {
case _PlaybackState() when $default != null:
return $default(_that.status,_that.position,_that.duration,_that.buffered,_that.speed,_that.isMuted,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PlaybackState extends PlaybackState {
  const _PlaybackState({this.status = PlaybackStatus.idle, this.position = Duration.zero, this.duration = Duration.zero, this.buffered = Duration.zero, this.speed = 1.0, this.isMuted = false, this.error}): super._();
  

@override@JsonKey() final  PlaybackStatus status;
@override@JsonKey() final  Duration position;
@override@JsonKey() final  Duration duration;
/// How far the stream has buffered ahead.
@override@JsonKey() final  Duration buffered;
@override@JsonKey() final  double speed;
@override@JsonKey() final  bool isMuted;
/// Set only when [status] is [PlaybackStatus.failed].
@override final  AppException? error;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaybackStateCopyWith<_PlaybackState> get copyWith => __$PlaybackStateCopyWithImpl<_PlaybackState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlaybackState&&(identical(other.status, status) || other.status == status)&&(identical(other.position, position) || other.position == position)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.buffered, buffered) || other.buffered == buffered)&&(identical(other.speed, speed) || other.speed == speed)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,status,position,duration,buffered,speed,isMuted,error);

@override
String toString() {
  return 'PlaybackState(status: $status, position: $position, duration: $duration, buffered: $buffered, speed: $speed, isMuted: $isMuted, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PlaybackStateCopyWith<$Res> implements $PlaybackStateCopyWith<$Res> {
  factory _$PlaybackStateCopyWith(_PlaybackState value, $Res Function(_PlaybackState) _then) = __$PlaybackStateCopyWithImpl;
@override @useResult
$Res call({
 PlaybackStatus status, Duration position, Duration duration, Duration buffered, double speed, bool isMuted, AppException? error
});




}
/// @nodoc
class __$PlaybackStateCopyWithImpl<$Res>
    implements _$PlaybackStateCopyWith<$Res> {
  __$PlaybackStateCopyWithImpl(this._self, this._then);

  final _PlaybackState _self;
  final $Res Function(_PlaybackState) _then;

/// Create a copy of PlaybackState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? position = null,Object? duration = null,Object? buffered = null,Object? speed = null,Object? isMuted = null,Object? error = freezed,}) {
  return _then(_PlaybackState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PlaybackStatus,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as Duration,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,buffered: null == buffered ? _self.buffered : buffered // ignore: cast_nullable_to_non_nullable
as Duration,speed: null == speed ? _self.speed : speed // ignore: cast_nullable_to_non_nullable
as double,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}


}

// dart format on
