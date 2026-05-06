// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_innings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppInnings {

 String get inningsId; String get matchId; String get battingTeamName; String get bowlingTeamName; String? get battingTeamId; String? get bowlingTeamId; int get totalRuns; int get wickets; double get overs;
/// Create a copy of AppInnings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppInningsCopyWith<AppInnings> get copyWith => _$AppInningsCopyWithImpl<AppInnings>(this as AppInnings, _$identity);

  /// Serializes this AppInnings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppInnings&&(identical(other.inningsId, inningsId) || other.inningsId == inningsId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.battingTeamName, battingTeamName) || other.battingTeamName == battingTeamName)&&(identical(other.bowlingTeamName, bowlingTeamName) || other.bowlingTeamName == bowlingTeamName)&&(identical(other.battingTeamId, battingTeamId) || other.battingTeamId == battingTeamId)&&(identical(other.bowlingTeamId, bowlingTeamId) || other.bowlingTeamId == bowlingTeamId)&&(identical(other.totalRuns, totalRuns) || other.totalRuns == totalRuns)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.overs, overs) || other.overs == overs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inningsId,matchId,battingTeamName,bowlingTeamName,battingTeamId,bowlingTeamId,totalRuns,wickets,overs);

@override
String toString() {
  return 'AppInnings(inningsId: $inningsId, matchId: $matchId, battingTeamName: $battingTeamName, bowlingTeamName: $bowlingTeamName, battingTeamId: $battingTeamId, bowlingTeamId: $bowlingTeamId, totalRuns: $totalRuns, wickets: $wickets, overs: $overs)';
}


}

/// @nodoc
abstract mixin class $AppInningsCopyWith<$Res>  {
  factory $AppInningsCopyWith(AppInnings value, $Res Function(AppInnings) _then) = _$AppInningsCopyWithImpl;
@useResult
$Res call({
 String inningsId, String matchId, String battingTeamName, String bowlingTeamName, String? battingTeamId, String? bowlingTeamId, int totalRuns, int wickets, double overs
});




}
/// @nodoc
class _$AppInningsCopyWithImpl<$Res>
    implements $AppInningsCopyWith<$Res> {
  _$AppInningsCopyWithImpl(this._self, this._then);

  final AppInnings _self;
  final $Res Function(AppInnings) _then;

/// Create a copy of AppInnings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? inningsId = null,Object? matchId = null,Object? battingTeamName = null,Object? bowlingTeamName = null,Object? battingTeamId = freezed,Object? bowlingTeamId = freezed,Object? totalRuns = null,Object? wickets = null,Object? overs = null,}) {
  return _then(_self.copyWith(
inningsId: null == inningsId ? _self.inningsId : inningsId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,battingTeamName: null == battingTeamName ? _self.battingTeamName : battingTeamName // ignore: cast_nullable_to_non_nullable
as String,bowlingTeamName: null == bowlingTeamName ? _self.bowlingTeamName : bowlingTeamName // ignore: cast_nullable_to_non_nullable
as String,battingTeamId: freezed == battingTeamId ? _self.battingTeamId : battingTeamId // ignore: cast_nullable_to_non_nullable
as String?,bowlingTeamId: freezed == bowlingTeamId ? _self.bowlingTeamId : bowlingTeamId // ignore: cast_nullable_to_non_nullable
as String?,totalRuns: null == totalRuns ? _self.totalRuns : totalRuns // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AppInnings].
extension AppInningsPatterns on AppInnings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppInnings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppInnings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppInnings value)  $default,){
final _that = this;
switch (_that) {
case _AppInnings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppInnings value)?  $default,){
final _that = this;
switch (_that) {
case _AppInnings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String inningsId,  String matchId,  String battingTeamName,  String bowlingTeamName,  String? battingTeamId,  String? bowlingTeamId,  int totalRuns,  int wickets,  double overs)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppInnings() when $default != null:
return $default(_that.inningsId,_that.matchId,_that.battingTeamName,_that.bowlingTeamName,_that.battingTeamId,_that.bowlingTeamId,_that.totalRuns,_that.wickets,_that.overs);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String inningsId,  String matchId,  String battingTeamName,  String bowlingTeamName,  String? battingTeamId,  String? bowlingTeamId,  int totalRuns,  int wickets,  double overs)  $default,) {final _that = this;
switch (_that) {
case _AppInnings():
return $default(_that.inningsId,_that.matchId,_that.battingTeamName,_that.bowlingTeamName,_that.battingTeamId,_that.bowlingTeamId,_that.totalRuns,_that.wickets,_that.overs);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String inningsId,  String matchId,  String battingTeamName,  String bowlingTeamName,  String? battingTeamId,  String? bowlingTeamId,  int totalRuns,  int wickets,  double overs)?  $default,) {final _that = this;
switch (_that) {
case _AppInnings() when $default != null:
return $default(_that.inningsId,_that.matchId,_that.battingTeamName,_that.bowlingTeamName,_that.battingTeamId,_that.bowlingTeamId,_that.totalRuns,_that.wickets,_that.overs);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppInnings implements AppInnings {
  const _AppInnings({required this.inningsId, required this.matchId, required this.battingTeamName, required this.bowlingTeamName, this.battingTeamId, this.bowlingTeamId, required this.totalRuns, required this.wickets, required this.overs});
  factory _AppInnings.fromJson(Map<String, dynamic> json) => _$AppInningsFromJson(json);

@override final  String inningsId;
@override final  String matchId;
@override final  String battingTeamName;
@override final  String bowlingTeamName;
@override final  String? battingTeamId;
@override final  String? bowlingTeamId;
@override final  int totalRuns;
@override final  int wickets;
@override final  double overs;

/// Create a copy of AppInnings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppInningsCopyWith<_AppInnings> get copyWith => __$AppInningsCopyWithImpl<_AppInnings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppInningsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppInnings&&(identical(other.inningsId, inningsId) || other.inningsId == inningsId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.battingTeamName, battingTeamName) || other.battingTeamName == battingTeamName)&&(identical(other.bowlingTeamName, bowlingTeamName) || other.bowlingTeamName == bowlingTeamName)&&(identical(other.battingTeamId, battingTeamId) || other.battingTeamId == battingTeamId)&&(identical(other.bowlingTeamId, bowlingTeamId) || other.bowlingTeamId == bowlingTeamId)&&(identical(other.totalRuns, totalRuns) || other.totalRuns == totalRuns)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.overs, overs) || other.overs == overs));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,inningsId,matchId,battingTeamName,bowlingTeamName,battingTeamId,bowlingTeamId,totalRuns,wickets,overs);

@override
String toString() {
  return 'AppInnings(inningsId: $inningsId, matchId: $matchId, battingTeamName: $battingTeamName, bowlingTeamName: $bowlingTeamName, battingTeamId: $battingTeamId, bowlingTeamId: $bowlingTeamId, totalRuns: $totalRuns, wickets: $wickets, overs: $overs)';
}


}

/// @nodoc
abstract mixin class _$AppInningsCopyWith<$Res> implements $AppInningsCopyWith<$Res> {
  factory _$AppInningsCopyWith(_AppInnings value, $Res Function(_AppInnings) _then) = __$AppInningsCopyWithImpl;
@override @useResult
$Res call({
 String inningsId, String matchId, String battingTeamName, String bowlingTeamName, String? battingTeamId, String? bowlingTeamId, int totalRuns, int wickets, double overs
});




}
/// @nodoc
class __$AppInningsCopyWithImpl<$Res>
    implements _$AppInningsCopyWith<$Res> {
  __$AppInningsCopyWithImpl(this._self, this._then);

  final _AppInnings _self;
  final $Res Function(_AppInnings) _then;

/// Create a copy of AppInnings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? inningsId = null,Object? matchId = null,Object? battingTeamName = null,Object? bowlingTeamName = null,Object? battingTeamId = freezed,Object? bowlingTeamId = freezed,Object? totalRuns = null,Object? wickets = null,Object? overs = null,}) {
  return _then(_AppInnings(
inningsId: null == inningsId ? _self.inningsId : inningsId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,battingTeamName: null == battingTeamName ? _self.battingTeamName : battingTeamName // ignore: cast_nullable_to_non_nullable
as String,bowlingTeamName: null == bowlingTeamName ? _self.bowlingTeamName : bowlingTeamName // ignore: cast_nullable_to_non_nullable
as String,battingTeamId: freezed == battingTeamId ? _self.battingTeamId : battingTeamId // ignore: cast_nullable_to_non_nullable
as String?,bowlingTeamId: freezed == bowlingTeamId ? _self.bowlingTeamId : bowlingTeamId // ignore: cast_nullable_to_non_nullable
as String?,totalRuns: null == totalRuns ? _self.totalRuns : totalRuns // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
