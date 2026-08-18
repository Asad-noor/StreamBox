// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_section.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContentSection {

 ContentSectionKind get kind; String get title; List<Content> get items;
/// Create a copy of ContentSection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContentSectionCopyWith<ContentSection> get copyWith => _$ContentSectionCopyWithImpl<ContentSection>(this as ContentSection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContentSection&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,kind,title,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ContentSection(kind: $kind, title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class $ContentSectionCopyWith<$Res>  {
  factory $ContentSectionCopyWith(ContentSection value, $Res Function(ContentSection) _then) = _$ContentSectionCopyWithImpl;
@useResult
$Res call({
 ContentSectionKind kind, String title, List<Content> items
});




}
/// @nodoc
class _$ContentSectionCopyWithImpl<$Res>
    implements $ContentSectionCopyWith<$Res> {
  _$ContentSectionCopyWithImpl(this._self, this._then);

  final ContentSection _self;
  final $Res Function(ContentSection) _then;

/// Create a copy of ContentSection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? title = null,Object? items = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContentSectionKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Content>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContentSection].
extension ContentSectionPatterns on ContentSection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContentSection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContentSection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContentSection value)  $default,){
final _that = this;
switch (_that) {
case _ContentSection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContentSection value)?  $default,){
final _that = this;
switch (_that) {
case _ContentSection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ContentSectionKind kind,  String title,  List<Content> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContentSection() when $default != null:
return $default(_that.kind,_that.title,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ContentSectionKind kind,  String title,  List<Content> items)  $default,) {final _that = this;
switch (_that) {
case _ContentSection():
return $default(_that.kind,_that.title,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ContentSectionKind kind,  String title,  List<Content> items)?  $default,) {final _that = this;
switch (_that) {
case _ContentSection() when $default != null:
return $default(_that.kind,_that.title,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ContentSection extends ContentSection {
  const _ContentSection({required this.kind, required this.title, required final  List<Content> items}): _items = items,super._();
  

@override final  ContentSectionKind kind;
@override final  String title;
 final  List<Content> _items;
@override List<Content> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ContentSection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContentSectionCopyWith<_ContentSection> get copyWith => __$ContentSectionCopyWithImpl<_ContentSection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContentSection&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,kind,title,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ContentSection(kind: $kind, title: $title, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ContentSectionCopyWith<$Res> implements $ContentSectionCopyWith<$Res> {
  factory _$ContentSectionCopyWith(_ContentSection value, $Res Function(_ContentSection) _then) = __$ContentSectionCopyWithImpl;
@override @useResult
$Res call({
 ContentSectionKind kind, String title, List<Content> items
});




}
/// @nodoc
class __$ContentSectionCopyWithImpl<$Res>
    implements _$ContentSectionCopyWith<$Res> {
  __$ContentSectionCopyWithImpl(this._self, this._then);

  final _ContentSection _self;
  final $Res Function(_ContentSection) _then;

/// Create a copy of ContentSection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? title = null,Object? items = null,}) {
  return _then(_ContentSection(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ContentSectionKind,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Content>,
  ));
}


}

// dart format on
