// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_ball.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppBall {

 String get ballId; String get matchId; String get inningsId; int get overNumber; int get ballNumber;// 1 to 6 usually
 String get batsmanName; String get bowlerName; int get runs; String? get extraType;// 'wide', 'no_ball', 'bye', 'leg_bye', null
 String? get wicketType;// 'bowled', 'caught', 'run_out', etc. null if no wait
 DateTime get timestamp;
/// Create a copy of AppBall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppBallCopyWith<AppBall> get copyWith => _$AppBallCopyWithImpl<AppBall>(this as AppBall, _$identity);

  /// Serializes this AppBall to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppBall&&(identical(other.ballId, ballId) || other.ballId == ballId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.inningsId, inningsId) || other.inningsId == inningsId)&&(identical(other.overNumber, overNumber) || other.overNumber == overNumber)&&(identical(other.ballNumber, ballNumber) || other.ballNumber == ballNumber)&&(identical(other.batsmanName, batsmanName) || other.batsmanName == batsmanName)&&(identical(other.bowlerName, bowlerName) || other.bowlerName == bowlerName)&&(identical(other.runs, runs) || other.runs == runs)&&(identical(other.extraType, extraType) || other.extraType == extraType)&&(identical(other.wicketType, wicketType) || other.wicketType == wicketType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ballId,matchId,inningsId,overNumber,ballNumber,batsmanName,bowlerName,runs,extraType,wicketType,timestamp);

@override
String toString() {
  return 'AppBall(ballId: $ballId, matchId: $matchId, inningsId: $inningsId, overNumber: $overNumber, ballNumber: $ballNumber, batsmanName: $batsmanName, bowlerName: $bowlerName, runs: $runs, extraType: $extraType, wicketType: $wicketType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AppBallCopyWith<$Res>  {
  factory $AppBallCopyWith(AppBall value, $Res Function(AppBall) _then) = _$AppBallCopyWithImpl;
@useResult
$Res call({
 String ballId, String matchId, String inningsId, int overNumber, int ballNumber, String batsmanName, String bowlerName, int runs, String? extraType, String? wicketType, DateTime timestamp
});




}
/// @nodoc
class _$AppBallCopyWithImpl<$Res>
    implements $AppBallCopyWith<$Res> {
  _$AppBallCopyWithImpl(this._self, this._then);

  final AppBall _self;
  final $Res Function(AppBall) _then;

/// Create a copy of AppBall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ballId = null,Object? matchId = null,Object? inningsId = null,Object? overNumber = null,Object? ballNumber = null,Object? batsmanName = null,Object? bowlerName = null,Object? runs = null,Object? extraType = freezed,Object? wicketType = freezed,Object? timestamp = null,}) {
  return _then(_self.copyWith(
ballId: null == ballId ? _self.ballId : ballId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,inningsId: null == inningsId ? _self.inningsId : inningsId // ignore: cast_nullable_to_non_nullable
as String,overNumber: null == overNumber ? _self.overNumber : overNumber // ignore: cast_nullable_to_non_nullable
as int,ballNumber: null == ballNumber ? _self.ballNumber : ballNumber // ignore: cast_nullable_to_non_nullable
as int,batsmanName: null == batsmanName ? _self.batsmanName : batsmanName // ignore: cast_nullable_to_non_nullable
as String,bowlerName: null == bowlerName ? _self.bowlerName : bowlerName // ignore: cast_nullable_to_non_nullable
as String,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as int,extraType: freezed == extraType ? _self.extraType : extraType // ignore: cast_nullable_to_non_nullable
as String?,wicketType: freezed == wicketType ? _self.wicketType : wicketType // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppBall].
extension AppBallPatterns on AppBall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppBall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppBall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppBall value)  $default,){
final _that = this;
switch (_that) {
case _AppBall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppBall value)?  $default,){
final _that = this;
switch (_that) {
case _AppBall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ballId,  String matchId,  String inningsId,  int overNumber,  int ballNumber,  String batsmanName,  String bowlerName,  int runs,  String? extraType,  String? wicketType,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppBall() when $default != null:
return $default(_that.ballId,_that.matchId,_that.inningsId,_that.overNumber,_that.ballNumber,_that.batsmanName,_that.bowlerName,_that.runs,_that.extraType,_that.wicketType,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ballId,  String matchId,  String inningsId,  int overNumber,  int ballNumber,  String batsmanName,  String bowlerName,  int runs,  String? extraType,  String? wicketType,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _AppBall():
return $default(_that.ballId,_that.matchId,_that.inningsId,_that.overNumber,_that.ballNumber,_that.batsmanName,_that.bowlerName,_that.runs,_that.extraType,_that.wicketType,_that.timestamp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ballId,  String matchId,  String inningsId,  int overNumber,  int ballNumber,  String batsmanName,  String bowlerName,  int runs,  String? extraType,  String? wicketType,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AppBall() when $default != null:
return $default(_that.ballId,_that.matchId,_that.inningsId,_that.overNumber,_that.ballNumber,_that.batsmanName,_that.bowlerName,_that.runs,_that.extraType,_that.wicketType,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppBall implements AppBall {
  const _AppBall({required this.ballId, required this.matchId, required this.inningsId, required this.overNumber, required this.ballNumber, required this.batsmanName, required this.bowlerName, required this.runs, required this.extraType, required this.wicketType, required this.timestamp});
  factory _AppBall.fromJson(Map<String, dynamic> json) => _$AppBallFromJson(json);

@override final  String ballId;
@override final  String matchId;
@override final  String inningsId;
@override final  int overNumber;
@override final  int ballNumber;
// 1 to 6 usually
@override final  String batsmanName;
@override final  String bowlerName;
@override final  int runs;
@override final  String? extraType;
// 'wide', 'no_ball', 'bye', 'leg_bye', null
@override final  String? wicketType;
// 'bowled', 'caught', 'run_out', etc. null if no wait
@override final  DateTime timestamp;

/// Create a copy of AppBall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppBallCopyWith<_AppBall> get copyWith => __$AppBallCopyWithImpl<_AppBall>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppBallToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppBall&&(identical(other.ballId, ballId) || other.ballId == ballId)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.inningsId, inningsId) || other.inningsId == inningsId)&&(identical(other.overNumber, overNumber) || other.overNumber == overNumber)&&(identical(other.ballNumber, ballNumber) || other.ballNumber == ballNumber)&&(identical(other.batsmanName, batsmanName) || other.batsmanName == batsmanName)&&(identical(other.bowlerName, bowlerName) || other.bowlerName == bowlerName)&&(identical(other.runs, runs) || other.runs == runs)&&(identical(other.extraType, extraType) || other.extraType == extraType)&&(identical(other.wicketType, wicketType) || other.wicketType == wicketType)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ballId,matchId,inningsId,overNumber,ballNumber,batsmanName,bowlerName,runs,extraType,wicketType,timestamp);

@override
String toString() {
  return 'AppBall(ballId: $ballId, matchId: $matchId, inningsId: $inningsId, overNumber: $overNumber, ballNumber: $ballNumber, batsmanName: $batsmanName, bowlerName: $bowlerName, runs: $runs, extraType: $extraType, wicketType: $wicketType, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AppBallCopyWith<$Res> implements $AppBallCopyWith<$Res> {
  factory _$AppBallCopyWith(_AppBall value, $Res Function(_AppBall) _then) = __$AppBallCopyWithImpl;
@override @useResult
$Res call({
 String ballId, String matchId, String inningsId, int overNumber, int ballNumber, String batsmanName, String bowlerName, int runs, String? extraType, String? wicketType, DateTime timestamp
});




}
/// @nodoc
class __$AppBallCopyWithImpl<$Res>
    implements _$AppBallCopyWith<$Res> {
  __$AppBallCopyWithImpl(this._self, this._then);

  final _AppBall _self;
  final $Res Function(_AppBall) _then;

/// Create a copy of AppBall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ballId = null,Object? matchId = null,Object? inningsId = null,Object? overNumber = null,Object? ballNumber = null,Object? batsmanName = null,Object? bowlerName = null,Object? runs = null,Object? extraType = freezed,Object? wicketType = freezed,Object? timestamp = null,}) {
  return _then(_AppBall(
ballId: null == ballId ? _self.ballId : ballId // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,inningsId: null == inningsId ? _self.inningsId : inningsId // ignore: cast_nullable_to_non_nullable
as String,overNumber: null == overNumber ? _self.overNumber : overNumber // ignore: cast_nullable_to_non_nullable
as int,ballNumber: null == ballNumber ? _self.ballNumber : ballNumber // ignore: cast_nullable_to_non_nullable
as int,batsmanName: null == batsmanName ? _self.batsmanName : batsmanName // ignore: cast_nullable_to_non_nullable
as String,bowlerName: null == bowlerName ? _self.bowlerName : bowlerName // ignore: cast_nullable_to_non_nullable
as String,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as int,extraType: freezed == extraType ? _self.extraType : extraType // ignore: cast_nullable_to_non_nullable
as String?,wicketType: freezed == wicketType ? _self.wicketType : wicketType // ignore: cast_nullable_to_non_nullable
as String?,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
