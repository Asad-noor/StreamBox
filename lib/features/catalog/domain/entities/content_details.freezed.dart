// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_details.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentDetails {

 Content get content;/// Always empty for a movie.
 List<Season> get seasons;
/// Create a copy of ContentDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentDetailsCopyWith<ContentDetails> get copyWith => _$ContentDetailsCopyWithImpl<ContentDetails>(this as ContentDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentDetails&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.seasons, seasons));
}


@override
int get hashCode => Object.hash(runtimeType,content,const DeepCollectionEquality().hash(seasons));

@override
String toString() {
  return 'ContentDetails(content: $content, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class $ContentDetailsCopyWith<$Res>  {
  factory $ContentDetailsCopyWith(ContentDetails value, $Res Function(ContentDetails) _then) = _$ContentDetailsCopyWithImpl;
@useResult
$Res call({
 Content content, List<Season> seasons
});


$ContentCopyWith<$Res> get content;

}
/// @nodoc
class _$ContentDetailsCopyWithImpl<$Res>
    implements $ContentDetailsCopyWith<$Res> {
  _$ContentDetailsCopyWithImpl(this._self, this._then);

  final ContentDetails _self;
  final $Res Function(ContentDetails) _then;

/// Create a copy of ContentDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = null,Object? seasons = null,}) {
  return _then(_self.copyWith(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as Content,seasons: null == seasons ? _self.seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<Season>,
  ));
}
/// Create a copy of ContentDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentCopyWith<$Res> get content {
  
  return $ContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContentDetails].
extension ContentDetailsPatterns on ContentDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentDetails value)  $default,){
final _that = this;
switch (_that) {
case _ContentDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentDetails value)?  $default,){
final _that = this;
switch (_that) {
case _ContentDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Content content,  List<Season> seasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentDetails() when $default != null:
return $default(_that.content,_that.seasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Content content,  List<Season> seasons)  $default,) {final _that = this;
switch (_that) {
case _ContentDetails():
return $default(_that.content,_that.seasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Content content,  List<Season> seasons)?  $default,) {final _that = this;
switch (_that) {
case _ContentDetails() when $default != null:
return $default(_that.content,_that.seasons);case _:
  return null;

}
}

}

/// @nodoc


class _ContentDetails extends ContentDetails {
  const _ContentDetails({required this.content, final  List<Season> seasons = const <Season>[]}): _seasons = seasons,super._();
  

@override final  Content content;
/// Always empty for a movie.
 final  List<Season> _seasons;
/// Always empty for a movie.
@override@JsonKey() List<Season> get seasons {
  if (_seasons is EqualUnmodifiableListView) return _seasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_seasons);
}


/// Create a copy of ContentDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentDetailsCopyWith<_ContentDetails> get copyWith => __$ContentDetailsCopyWithImpl<_ContentDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentDetails&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other._seasons, _seasons));
}


@override
int get hashCode => Object.hash(runtimeType,content,const DeepCollectionEquality().hash(_seasons));

@override
String toString() {
  return 'ContentDetails(content: $content, seasons: $seasons)';
}


}

/// @nodoc
abstract mixin class _$ContentDetailsCopyWith<$Res> implements $ContentDetailsCopyWith<$Res> {
  factory _$ContentDetailsCopyWith(_ContentDetails value, $Res Function(_ContentDetails) _then) = __$ContentDetailsCopyWithImpl;
@override @useResult
$Res call({
 Content content, List<Season> seasons
});


@override $ContentCopyWith<$Res> get content;

}
/// @nodoc
class __$ContentDetailsCopyWithImpl<$Res>
    implements _$ContentDetailsCopyWith<$Res> {
  __$ContentDetailsCopyWithImpl(this._self, this._then);

  final _ContentDetails _self;
  final $Res Function(_ContentDetails) _then;

/// Create a copy of ContentDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = null,Object? seasons = null,}) {
  return _then(_ContentDetails(
content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as Content,seasons: null == seasons ? _self._seasons : seasons // ignore: cast_nullable_to_non_nullable
as List<Season>,
  ));
}

/// Create a copy of ContentDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentCopyWith<$Res> get content {
  
  return $ContentCopyWith<$Res>(_self.content, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}

// dart format on
