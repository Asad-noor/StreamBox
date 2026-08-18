// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_feed.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeFeed {

/// The promoted title. Null when the catalogue is empty.
 Content? get featured; List<ContentSection> get sections;
/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeFeedCopyWith<HomeFeed> get copyWith => _$HomeFeedCopyWithImpl<HomeFeed>(this as HomeFeed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeFeed&&(identical(other.featured, featured) || other.featured == featured)&&const DeepCollectionEquality().equals(other.sections, sections));
}


@override
int get hashCode => Object.hash(runtimeType,featured,const DeepCollectionEquality().hash(sections));

@override
String toString() {
  return 'HomeFeed(featured: $featured, sections: $sections)';
}


}

/// @nodoc
abstract mixin class $HomeFeedCopyWith<$Res>  {
  factory $HomeFeedCopyWith(HomeFeed value, $Res Function(HomeFeed) _then) = _$HomeFeedCopyWithImpl;
@useResult
$Res call({
 Content? featured, List<ContentSection> sections
});


$ContentCopyWith<$Res>? get featured;

}
/// @nodoc
class _$HomeFeedCopyWithImpl<$Res>
    implements $HomeFeedCopyWith<$Res> {
  _$HomeFeedCopyWithImpl(this._self, this._then);

  final HomeFeed _self;
  final $Res Function(HomeFeed) _then;

/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? featured = freezed,Object? sections = null,}) {
  return _then(_self.copyWith(
featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as Content?,sections: null == sections ? _self.sections : sections // ignore: cast_nullable_to_non_nullable
as List<ContentSection>,
  ));
}
/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentCopyWith<$Res>? get featured {
    if (_self.featured == null) {
    return null;
  }

  return $ContentCopyWith<$Res>(_self.featured!, (value) {
    return _then(_self.copyWith(featured: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeFeed].
extension HomeFeedPatterns on HomeFeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeFeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeFeed value)  $default,){
final _that = this;
switch (_that) {
case _HomeFeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeFeed value)?  $default,){
final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Content? featured,  List<ContentSection> sections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
return $default(_that.featured,_that.sections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Content? featured,  List<ContentSection> sections)  $default,) {final _that = this;
switch (_that) {
case _HomeFeed():
return $default(_that.featured,_that.sections);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Content? featured,  List<ContentSection> sections)?  $default,) {final _that = this;
switch (_that) {
case _HomeFeed() when $default != null:
return $default(_that.featured,_that.sections);case _:
  return null;

}
}

}

/// @nodoc


class _HomeFeed extends HomeFeed {
  const _HomeFeed({required this.featured, required final  List<ContentSection> sections}): _sections = sections,super._();
  

/// The promoted title. Null when the catalogue is empty.
@override final  Content? featured;
 final  List<ContentSection> _sections;
@override List<ContentSection> get sections {
  if (_sections is EqualUnmodifiableListView) return _sections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sections);
}


/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeFeedCopyWith<_HomeFeed> get copyWith => __$HomeFeedCopyWithImpl<_HomeFeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeFeed&&(identical(other.featured, featured) || other.featured == featured)&&const DeepCollectionEquality().equals(other._sections, _sections));
}


@override
int get hashCode => Object.hash(runtimeType,featured,const DeepCollectionEquality().hash(_sections));

@override
String toString() {
  return 'HomeFeed(featured: $featured, sections: $sections)';
}


}

/// @nodoc
abstract mixin class _$HomeFeedCopyWith<$Res> implements $HomeFeedCopyWith<$Res> {
  factory _$HomeFeedCopyWith(_HomeFeed value, $Res Function(_HomeFeed) _then) = __$HomeFeedCopyWithImpl;
@override @useResult
$Res call({
 Content? featured, List<ContentSection> sections
});


@override $ContentCopyWith<$Res>? get featured;

}
/// @nodoc
class __$HomeFeedCopyWithImpl<$Res>
    implements _$HomeFeedCopyWith<$Res> {
  __$HomeFeedCopyWithImpl(this._self, this._then);

  final _HomeFeed _self;
  final $Res Function(_HomeFeed) _then;

/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? featured = freezed,Object? sections = null,}) {
  return _then(_HomeFeed(
featured: freezed == featured ? _self.featured : featured // ignore: cast_nullable_to_non_nullable
as Content?,sections: null == sections ? _self._sections : sections // ignore: cast_nullable_to_non_nullable
as List<ContentSection>,
  ));
}

/// Create a copy of HomeFeed
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContentCopyWith<$Res>? get featured {
    if (_self.featured == null) {
    return null;
  }

  return $ContentCopyWith<$Res>(_self.featured!, (value) {
    return _then(_self.copyWith(featured: value));
  });
}
}

// dart format on
