// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchIdle value)?  idle,TResult Function( SearchLoading value)?  loading,TResult Function( SearchSuccess value)?  success,TResult Function( SearchEmpty value)?  empty,TResult Function( SearchFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchSuccess() when success != null:
return success(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchIdle value)  idle,required TResult Function( SearchLoading value)  loading,required TResult Function( SearchSuccess value)  success,required TResult Function( SearchEmpty value)  empty,required TResult Function( SearchFailure value)  failure,}){
final _that = this;
switch (_that) {
case SearchIdle():
return idle(_that);case SearchLoading():
return loading(_that);case SearchSuccess():
return success(_that);case SearchEmpty():
return empty(_that);case SearchFailure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchIdle value)?  idle,TResult? Function( SearchLoading value)?  loading,TResult? Function( SearchSuccess value)?  success,TResult? Function( SearchEmpty value)?  empty,TResult? Function( SearchFailure value)?  failure,}){
final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle(_that);case SearchLoading() when loading != null:
return loading(_that);case SearchSuccess() when success != null:
return success(_that);case SearchEmpty() when empty != null:
return empty(_that);case SearchFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( String query)?  loading,TResult Function( String query,  SearchResults results,  bool isLoadingMore,  AppException? pageError)?  success,TResult Function( String query)?  empty,TResult Function( String query,  AppException error)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle();case SearchLoading() when loading != null:
return loading(_that.query);case SearchSuccess() when success != null:
return success(_that.query,_that.results,_that.isLoadingMore,_that.pageError);case SearchEmpty() when empty != null:
return empty(_that.query);case SearchFailure() when failure != null:
return failure(_that.query,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( String query)  loading,required TResult Function( String query,  SearchResults results,  bool isLoadingMore,  AppException? pageError)  success,required TResult Function( String query)  empty,required TResult Function( String query,  AppException error)  failure,}) {final _that = this;
switch (_that) {
case SearchIdle():
return idle();case SearchLoading():
return loading(_that.query);case SearchSuccess():
return success(_that.query,_that.results,_that.isLoadingMore,_that.pageError);case SearchEmpty():
return empty(_that.query);case SearchFailure():
return failure(_that.query,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( String query)?  loading,TResult? Function( String query,  SearchResults results,  bool isLoadingMore,  AppException? pageError)?  success,TResult? Function( String query)?  empty,TResult? Function( String query,  AppException error)?  failure,}) {final _that = this;
switch (_that) {
case SearchIdle() when idle != null:
return idle();case SearchLoading() when loading != null:
return loading(_that.query);case SearchSuccess() when success != null:
return success(_that.query,_that.results,_that.isLoadingMore,_that.pageError);case SearchEmpty() when empty != null:
return empty(_that.query);case SearchFailure() when failure != null:
return failure(_that.query,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class SearchIdle extends SearchState {
  const SearchIdle(): super._();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.idle()';
}


}




/// @nodoc


class SearchLoading extends SearchState {
  const SearchLoading({required this.query}): super._();
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchLoadingCopyWith<SearchLoading> get copyWith => _$SearchLoadingCopyWithImpl<SearchLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchLoading&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchState.loading(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchLoadingCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchLoadingCopyWith(SearchLoading value, $Res Function(SearchLoading) _then) = _$SearchLoadingCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchLoadingCopyWithImpl<$Res>
    implements $SearchLoadingCopyWith<$Res> {
  _$SearchLoadingCopyWithImpl(this._self, this._then);

  final SearchLoading _self;
  final $Res Function(SearchLoading) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchLoading(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchSuccess extends SearchState {
  const SearchSuccess({required this.query, required this.results, this.isLoadingMore = false, this.pageError}): super._();
  

 final  String query;
 final  SearchResults results;
/// True while the next page is being appended. Results stay visible.
@JsonKey() final  bool isLoadingMore;
/// Set when appending a page failed. The already-loaded results remain,
/// and the UI offers to retry just the failed page.
 final  AppException? pageError;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchSuccessCopyWith<SearchSuccess> get copyWith => _$SearchSuccessCopyWithImpl<SearchSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchSuccess&&(identical(other.query, query) || other.query == query)&&(identical(other.results, results) || other.results == results)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.pageError, pageError) || other.pageError == pageError));
}


@override
int get hashCode => Object.hash(runtimeType,query,results,isLoadingMore,pageError);

@override
String toString() {
  return 'SearchState.success(query: $query, results: $results, isLoadingMore: $isLoadingMore, pageError: $pageError)';
}


}

/// @nodoc
abstract mixin class $SearchSuccessCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchSuccessCopyWith(SearchSuccess value, $Res Function(SearchSuccess) _then) = _$SearchSuccessCopyWithImpl;
@useResult
$Res call({
 String query, SearchResults results, bool isLoadingMore, AppException? pageError
});


$SearchResultsCopyWith<$Res> get results;

}
/// @nodoc
class _$SearchSuccessCopyWithImpl<$Res>
    implements $SearchSuccessCopyWith<$Res> {
  _$SearchSuccessCopyWithImpl(this._self, this._then);

  final SearchSuccess _self;
  final $Res Function(SearchSuccess) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? results = null,Object? isLoadingMore = null,Object? pageError = freezed,}) {
  return _then(SearchSuccess(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,results: null == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as SearchResults,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,pageError: freezed == pageError ? _self.pageError : pageError // ignore: cast_nullable_to_non_nullable
as AppException?,
  ));
}

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchResultsCopyWith<$Res> get results {
  
  return $SearchResultsCopyWith<$Res>(_self.results, (value) {
    return _then(_self.copyWith(results: value));
  });
}
}

/// @nodoc


class SearchEmpty extends SearchState {
  const SearchEmpty({required this.query}): super._();
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchEmptyCopyWith<SearchEmpty> get copyWith => _$SearchEmptyCopyWithImpl<SearchEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchEmpty&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchState.empty(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchEmptyCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchEmptyCopyWith(SearchEmpty value, $Res Function(SearchEmpty) _then) = _$SearchEmptyCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchEmptyCopyWithImpl<$Res>
    implements $SearchEmptyCopyWith<$Res> {
  _$SearchEmptyCopyWithImpl(this._self, this._then);

  final SearchEmpty _self;
  final $Res Function(SearchEmpty) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchEmpty(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchFailure extends SearchState {
  const SearchFailure({required this.query, required this.error}): super._();
  

 final  String query;
 final  AppException error;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchFailureCopyWith<SearchFailure> get copyWith => _$SearchFailureCopyWithImpl<SearchFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchFailure&&(identical(other.query, query) || other.query == query)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,query,error);

@override
String toString() {
  return 'SearchState.failure(query: $query, error: $error)';
}


}

/// @nodoc
abstract mixin class $SearchFailureCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchFailureCopyWith(SearchFailure value, $Res Function(SearchFailure) _then) = _$SearchFailureCopyWithImpl;
@useResult
$Res call({
 String query, AppException error
});




}
/// @nodoc
class _$SearchFailureCopyWithImpl<$Res>
    implements $SearchFailureCopyWith<$Res> {
  _$SearchFailureCopyWithImpl(this._self, this._then);

  final SearchFailure _self;
  final $Res Function(SearchFailure) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,Object? error = null,}) {
  return _then(SearchFailure(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,error: null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as AppException,
  ));
}


}

// dart format on
