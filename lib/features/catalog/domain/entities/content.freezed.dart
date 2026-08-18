// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Content {

 String get id; String get title; ContentType get type; String get synopsis; String get posterUrl; String get backdropUrl; int get releaseYear; List<String> get genres;/// Out of 10, as it is conventionally displayed.
 double get rating;/// Total runtime for a movie, or of a single episode for a series.
 Duration get duration;/// The playable stream. Null while a title is announced but not yet
/// available, which the UI surfaces by disabling the watch action.
 String? get streamUrl;/// Series only.
 int? get seasonCount;
/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentCopyWith<Content> get copyWith => _$ContentCopyWithImpl<Content>(this as Content, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Content&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.synopsis, synopsis) || other.synopsis == synopsis)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.backdropUrl, backdropUrl) || other.backdropUrl == backdropUrl)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.seasonCount, seasonCount) || other.seasonCount == seasonCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,type,synopsis,posterUrl,backdropUrl,releaseYear,const DeepCollectionEquality().hash(genres),rating,duration,streamUrl,seasonCount);

@override
String toString() {
  return 'Content(id: $id, title: $title, type: $type, synopsis: $synopsis, posterUrl: $posterUrl, backdropUrl: $backdropUrl, releaseYear: $releaseYear, genres: $genres, rating: $rating, duration: $duration, streamUrl: $streamUrl, seasonCount: $seasonCount)';
}


}

/// @nodoc
abstract mixin class $ContentCopyWith<$Res>  {
  factory $ContentCopyWith(Content value, $Res Function(Content) _then) = _$ContentCopyWithImpl;
@useResult
$Res call({
 String id, String title, ContentType type, String synopsis, String posterUrl, String backdropUrl, int releaseYear, List<String> genres, double rating, Duration duration, String? streamUrl, int? seasonCount
});




}
/// @nodoc
class _$ContentCopyWithImpl<$Res>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._self, this._then);

  final Content _self;
  final $Res Function(Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? type = null,Object? synopsis = null,Object? posterUrl = null,Object? backdropUrl = null,Object? releaseYear = null,Object? genres = null,Object? rating = null,Object? duration = null,Object? streamUrl = freezed,Object? seasonCount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContentType,synopsis: null == synopsis ? _self.synopsis : synopsis // ignore: cast_nullable_to_non_nullable
as String,posterUrl: null == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String,backdropUrl: null == backdropUrl ? _self.backdropUrl : backdropUrl // ignore: cast_nullable_to_non_nullable
as String,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,seasonCount: freezed == seasonCount ? _self.seasonCount : seasonCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Content].
extension ContentPatterns on Content {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Content value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Content() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Content value)  $default,){
final _that = this;
switch (_that) {
case _Content():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Content value)?  $default,){
final _that = this;
switch (_that) {
case _Content() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  ContentType type,  String synopsis,  String posterUrl,  String backdropUrl,  int releaseYear,  List<String> genres,  double rating,  Duration duration,  String? streamUrl,  int? seasonCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.synopsis,_that.posterUrl,_that.backdropUrl,_that.releaseYear,_that.genres,_that.rating,_that.duration,_that.streamUrl,_that.seasonCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  ContentType type,  String synopsis,  String posterUrl,  String backdropUrl,  int releaseYear,  List<String> genres,  double rating,  Duration duration,  String? streamUrl,  int? seasonCount)  $default,) {final _that = this;
switch (_that) {
case _Content():
return $default(_that.id,_that.title,_that.type,_that.synopsis,_that.posterUrl,_that.backdropUrl,_that.releaseYear,_that.genres,_that.rating,_that.duration,_that.streamUrl,_that.seasonCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  ContentType type,  String synopsis,  String posterUrl,  String backdropUrl,  int releaseYear,  List<String> genres,  double rating,  Duration duration,  String? streamUrl,  int? seasonCount)?  $default,) {final _that = this;
switch (_that) {
case _Content() when $default != null:
return $default(_that.id,_that.title,_that.type,_that.synopsis,_that.posterUrl,_that.backdropUrl,_that.releaseYear,_that.genres,_that.rating,_that.duration,_that.streamUrl,_that.seasonCount);case _:
  return null;

}
}

}

/// @nodoc


class _Content extends Content {
  const _Content({required this.id, required this.title, required this.type, required this.synopsis, required this.posterUrl, required this.backdropUrl, required this.releaseYear, required final  List<String> genres, required this.rating, required this.duration, this.streamUrl, this.seasonCount}): _genres = genres,super._();
  

@override final  String id;
@override final  String title;
@override final  ContentType type;
@override final  String synopsis;
@override final  String posterUrl;
@override final  String backdropUrl;
@override final  int releaseYear;
 final  List<String> _genres;
@override List<String> get genres {
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_genres);
}

/// Out of 10, as it is conventionally displayed.
@override final  double rating;
/// Total runtime for a movie, or of a single episode for a series.
@override final  Duration duration;
/// The playable stream. Null while a title is announced but not yet
/// available, which the UI surfaces by disabling the watch action.
@override final  String? streamUrl;
/// Series only.
@override final  int? seasonCount;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentCopyWith<_Content> get copyWith => __$ContentCopyWithImpl<_Content>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Content&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.type, type) || other.type == type)&&(identical(other.synopsis, synopsis) || other.synopsis == synopsis)&&(identical(other.posterUrl, posterUrl) || other.posterUrl == posterUrl)&&(identical(other.backdropUrl, backdropUrl) || other.backdropUrl == backdropUrl)&&(identical(other.releaseYear, releaseYear) || other.releaseYear == releaseYear)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.streamUrl, streamUrl) || other.streamUrl == streamUrl)&&(identical(other.seasonCount, seasonCount) || other.seasonCount == seasonCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,type,synopsis,posterUrl,backdropUrl,releaseYear,const DeepCollectionEquality().hash(_genres),rating,duration,streamUrl,seasonCount);

@override
String toString() {
  return 'Content(id: $id, title: $title, type: $type, synopsis: $synopsis, posterUrl: $posterUrl, backdropUrl: $backdropUrl, releaseYear: $releaseYear, genres: $genres, rating: $rating, duration: $duration, streamUrl: $streamUrl, seasonCount: $seasonCount)';
}


}

/// @nodoc
abstract mixin class _$ContentCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$ContentCopyWith(_Content value, $Res Function(_Content) _then) = __$ContentCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, ContentType type, String synopsis, String posterUrl, String backdropUrl, int releaseYear, List<String> genres, double rating, Duration duration, String? streamUrl, int? seasonCount
});




}
/// @nodoc
class __$ContentCopyWithImpl<$Res>
    implements _$ContentCopyWith<$Res> {
  __$ContentCopyWithImpl(this._self, this._then);

  final _Content _self;
  final $Res Function(_Content) _then;

/// Create a copy of Content
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? type = null,Object? synopsis = null,Object? posterUrl = null,Object? backdropUrl = null,Object? releaseYear = null,Object? genres = null,Object? rating = null,Object? duration = null,Object? streamUrl = freezed,Object? seasonCount = freezed,}) {
  return _then(_Content(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as ContentType,synopsis: null == synopsis ? _self.synopsis : synopsis // ignore: cast_nullable_to_non_nullable
as String,posterUrl: null == posterUrl ? _self.posterUrl : posterUrl // ignore: cast_nullable_to_non_nullable
as String,backdropUrl: null == backdropUrl ? _self.backdropUrl : backdropUrl // ignore: cast_nullable_to_non_nullable
as String,releaseYear: null == releaseYear ? _self.releaseYear : releaseYear // ignore: cast_nullable_to_non_nullable
as int,genres: null == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<String>,rating: null == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,streamUrl: freezed == streamUrl ? _self.streamUrl : streamUrl // ignore: cast_nullable_to_non_nullable
as String?,seasonCount: freezed == seasonCount ? _self.seasonCount : seasonCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
