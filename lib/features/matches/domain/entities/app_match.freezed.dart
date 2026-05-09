// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppMatch {

 String get matchId; String get teamAName; String get teamBName; String? get teamAId; String? get teamBId; String? get tournamentId; String? get sportId; int get overs; String get tossWinner; String get tossDecision;// 'bat' or 'bowl'
 String get matchStatus;// 'upcoming', 'live', 'completed'
 MatchPhase get currentPhase; int? get targetScore; String? get matchResult; String? get currentStrikerId; String? get currentNonStrikerId; String? get currentBowlerId; DateTime get createdAt;
/// Create a copy of AppMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppMatchCopyWith<AppMatch> get copyWith => _$AppMatchCopyWithImpl<AppMatch>(this as AppMatch, _$identity);

  /// Serializes this AppMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppMatch&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.teamAName, teamAName) || other.teamAName == teamAName)&&(identical(other.teamBName, teamBName) || other.teamBName == teamBName)&&(identical(other.teamAId, teamAId) || other.teamAId == teamAId)&&(identical(other.teamBId, teamBId) || other.teamBId == teamBId)&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.sportId, sportId) || other.sportId == sportId)&&(identical(other.overs, overs) || other.overs == overs)&&(identical(other.tossWinner, tossWinner) || other.tossWinner == tossWinner)&&(identical(other.tossDecision, tossDecision) || other.tossDecision == tossDecision)&&(identical(other.matchStatus, matchStatus) || other.matchStatus == matchStatus)&&(identical(other.currentPhase, currentPhase) || other.currentPhase == currentPhase)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.matchResult, matchResult) || other.matchResult == matchResult)&&(identical(other.currentStrikerId, currentStrikerId) || other.currentStrikerId == currentStrikerId)&&(identical(other.currentNonStrikerId, currentNonStrikerId) || other.currentNonStrikerId == currentNonStrikerId)&&(identical(other.currentBowlerId, currentBowlerId) || other.currentBowlerId == currentBowlerId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,teamAName,teamBName,teamAId,teamBId,tournamentId,sportId,overs,tossWinner,tossDecision,matchStatus,currentPhase,targetScore,matchResult,currentStrikerId,currentNonStrikerId,currentBowlerId,createdAt);

@override
String toString() {
  return 'AppMatch(matchId: $matchId, teamAName: $teamAName, teamBName: $teamBName, teamAId: $teamAId, teamBId: $teamBId, tournamentId: $tournamentId, sportId: $sportId, overs: $overs, tossWinner: $tossWinner, tossDecision: $tossDecision, matchStatus: $matchStatus, currentPhase: $currentPhase, targetScore: $targetScore, matchResult: $matchResult, currentStrikerId: $currentStrikerId, currentNonStrikerId: $currentNonStrikerId, currentBowlerId: $currentBowlerId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppMatchCopyWith<$Res>  {
  factory $AppMatchCopyWith(AppMatch value, $Res Function(AppMatch) _then) = _$AppMatchCopyWithImpl;
@useResult
$Res call({
 String matchId, String teamAName, String teamBName, String? teamAId, String? teamBId, String? tournamentId, String? sportId, int overs, String tossWinner, String tossDecision, String matchStatus, MatchPhase currentPhase, int? targetScore, String? matchResult, String? currentStrikerId, String? currentNonStrikerId, String? currentBowlerId, DateTime createdAt
});




}
/// @nodoc
class _$AppMatchCopyWithImpl<$Res>
    implements $AppMatchCopyWith<$Res> {
  _$AppMatchCopyWithImpl(this._self, this._then);

  final AppMatch _self;
  final $Res Function(AppMatch) _then;

/// Create a copy of AppMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? teamAName = null,Object? teamBName = null,Object? teamAId = freezed,Object? teamBId = freezed,Object? tournamentId = freezed,Object? sportId = freezed,Object? overs = null,Object? tossWinner = null,Object? tossDecision = null,Object? matchStatus = null,Object? currentPhase = null,Object? targetScore = freezed,Object? matchResult = freezed,Object? currentStrikerId = freezed,Object? currentNonStrikerId = freezed,Object? currentBowlerId = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,teamAName: null == teamAName ? _self.teamAName : teamAName // ignore: cast_nullable_to_non_nullable
as String,teamBName: null == teamBName ? _self.teamBName : teamBName // ignore: cast_nullable_to_non_nullable
as String,teamAId: freezed == teamAId ? _self.teamAId : teamAId // ignore: cast_nullable_to_non_nullable
as String?,teamBId: freezed == teamBId ? _self.teamBId : teamBId // ignore: cast_nullable_to_non_nullable
as String?,tournamentId: freezed == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String?,sportId: freezed == sportId ? _self.sportId : sportId // ignore: cast_nullable_to_non_nullable
as String?,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as int,tossWinner: null == tossWinner ? _self.tossWinner : tossWinner // ignore: cast_nullable_to_non_nullable
as String,tossDecision: null == tossDecision ? _self.tossDecision : tossDecision // ignore: cast_nullable_to_non_nullable
as String,matchStatus: null == matchStatus ? _self.matchStatus : matchStatus // ignore: cast_nullable_to_non_nullable
as String,currentPhase: null == currentPhase ? _self.currentPhase : currentPhase // ignore: cast_nullable_to_non_nullable
as MatchPhase,targetScore: freezed == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int?,matchResult: freezed == matchResult ? _self.matchResult : matchResult // ignore: cast_nullable_to_non_nullable
as String?,currentStrikerId: freezed == currentStrikerId ? _self.currentStrikerId : currentStrikerId // ignore: cast_nullable_to_non_nullable
as String?,currentNonStrikerId: freezed == currentNonStrikerId ? _self.currentNonStrikerId : currentNonStrikerId // ignore: cast_nullable_to_non_nullable
as String?,currentBowlerId: freezed == currentBowlerId ? _self.currentBowlerId : currentBowlerId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppMatch].
extension AppMatchPatterns on AppMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppMatch value)  $default,){
final _that = this;
switch (_that) {
case _AppMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppMatch value)?  $default,){
final _that = this;
switch (_that) {
case _AppMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String matchId,  String teamAName,  String teamBName,  String? teamAId,  String? teamBId,  String? tournamentId,  String? sportId,  int overs,  String tossWinner,  String tossDecision,  String matchStatus,  MatchPhase currentPhase,  int? targetScore,  String? matchResult,  String? currentStrikerId,  String? currentNonStrikerId,  String? currentBowlerId,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppMatch() when $default != null:
return $default(_that.matchId,_that.teamAName,_that.teamBName,_that.teamAId,_that.teamBId,_that.tournamentId,_that.sportId,_that.overs,_that.tossWinner,_that.tossDecision,_that.matchStatus,_that.currentPhase,_that.targetScore,_that.matchResult,_that.currentStrikerId,_that.currentNonStrikerId,_that.currentBowlerId,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String matchId,  String teamAName,  String teamBName,  String? teamAId,  String? teamBId,  String? tournamentId,  String? sportId,  int overs,  String tossWinner,  String tossDecision,  String matchStatus,  MatchPhase currentPhase,  int? targetScore,  String? matchResult,  String? currentStrikerId,  String? currentNonStrikerId,  String? currentBowlerId,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppMatch():
return $default(_that.matchId,_that.teamAName,_that.teamBName,_that.teamAId,_that.teamBId,_that.tournamentId,_that.sportId,_that.overs,_that.tossWinner,_that.tossDecision,_that.matchStatus,_that.currentPhase,_that.targetScore,_that.matchResult,_that.currentStrikerId,_that.currentNonStrikerId,_that.currentBowlerId,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String matchId,  String teamAName,  String teamBName,  String? teamAId,  String? teamBId,  String? tournamentId,  String? sportId,  int overs,  String tossWinner,  String tossDecision,  String matchStatus,  MatchPhase currentPhase,  int? targetScore,  String? matchResult,  String? currentStrikerId,  String? currentNonStrikerId,  String? currentBowlerId,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppMatch() when $default != null:
return $default(_that.matchId,_that.teamAName,_that.teamBName,_that.teamAId,_that.teamBId,_that.tournamentId,_that.sportId,_that.overs,_that.tossWinner,_that.tossDecision,_that.matchStatus,_that.currentPhase,_that.targetScore,_that.matchResult,_that.currentStrikerId,_that.currentNonStrikerId,_that.currentBowlerId,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppMatch implements AppMatch {
  const _AppMatch({required this.matchId, required this.teamAName, required this.teamBName, this.teamAId, this.teamBId, this.tournamentId, this.sportId, required this.overs, required this.tossWinner, required this.tossDecision, required this.matchStatus, this.currentPhase = MatchPhase.initial, this.targetScore, this.matchResult, this.currentStrikerId, this.currentNonStrikerId, this.currentBowlerId, required this.createdAt});
  factory _AppMatch.fromJson(Map<String, dynamic> json) => _$AppMatchFromJson(json);

@override final  String matchId;
@override final  String teamAName;
@override final  String teamBName;
@override final  String? teamAId;
@override final  String? teamBId;
@override final  String? tournamentId;
@override final  String? sportId;
@override final  int overs;
@override final  String tossWinner;
@override final  String tossDecision;
// 'bat' or 'bowl'
@override final  String matchStatus;
// 'upcoming', 'live', 'completed'
@override@JsonKey() final  MatchPhase currentPhase;
@override final  int? targetScore;
@override final  String? matchResult;
@override final  String? currentStrikerId;
@override final  String? currentNonStrikerId;
@override final  String? currentBowlerId;
@override final  DateTime createdAt;

/// Create a copy of AppMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppMatchCopyWith<_AppMatch> get copyWith => __$AppMatchCopyWithImpl<_AppMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppMatchToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppMatch&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.teamAName, teamAName) || other.teamAName == teamAName)&&(identical(other.teamBName, teamBName) || other.teamBName == teamBName)&&(identical(other.teamAId, teamAId) || other.teamAId == teamAId)&&(identical(other.teamBId, teamBId) || other.teamBId == teamBId)&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.sportId, sportId) || other.sportId == sportId)&&(identical(other.overs, overs) || other.overs == overs)&&(identical(other.tossWinner, tossWinner) || other.tossWinner == tossWinner)&&(identical(other.tossDecision, tossDecision) || other.tossDecision == tossDecision)&&(identical(other.matchStatus, matchStatus) || other.matchStatus == matchStatus)&&(identical(other.currentPhase, currentPhase) || other.currentPhase == currentPhase)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.matchResult, matchResult) || other.matchResult == matchResult)&&(identical(other.currentStrikerId, currentStrikerId) || other.currentStrikerId == currentStrikerId)&&(identical(other.currentNonStrikerId, currentNonStrikerId) || other.currentNonStrikerId == currentNonStrikerId)&&(identical(other.currentBowlerId, currentBowlerId) || other.currentBowlerId == currentBowlerId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,matchId,teamAName,teamBName,teamAId,teamBId,tournamentId,sportId,overs,tossWinner,tossDecision,matchStatus,currentPhase,targetScore,matchResult,currentStrikerId,currentNonStrikerId,currentBowlerId,createdAt);

@override
String toString() {
  return 'AppMatch(matchId: $matchId, teamAName: $teamAName, teamBName: $teamBName, teamAId: $teamAId, teamBId: $teamBId, tournamentId: $tournamentId, sportId: $sportId, overs: $overs, tossWinner: $tossWinner, tossDecision: $tossDecision, matchStatus: $matchStatus, currentPhase: $currentPhase, targetScore: $targetScore, matchResult: $matchResult, currentStrikerId: $currentStrikerId, currentNonStrikerId: $currentNonStrikerId, currentBowlerId: $currentBowlerId, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppMatchCopyWith<$Res> implements $AppMatchCopyWith<$Res> {
  factory _$AppMatchCopyWith(_AppMatch value, $Res Function(_AppMatch) _then) = __$AppMatchCopyWithImpl;
@override @useResult
$Res call({
 String matchId, String teamAName, String teamBName, String? teamAId, String? teamBId, String? tournamentId, String? sportId, int overs, String tossWinner, String tossDecision, String matchStatus, MatchPhase currentPhase, int? targetScore, String? matchResult, String? currentStrikerId, String? currentNonStrikerId, String? currentBowlerId, DateTime createdAt
});




}
/// @nodoc
class __$AppMatchCopyWithImpl<$Res>
    implements _$AppMatchCopyWith<$Res> {
  __$AppMatchCopyWithImpl(this._self, this._then);

  final _AppMatch _self;
  final $Res Function(_AppMatch) _then;

/// Create a copy of AppMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? teamAName = null,Object? teamBName = null,Object? teamAId = freezed,Object? teamBId = freezed,Object? tournamentId = freezed,Object? sportId = freezed,Object? overs = null,Object? tossWinner = null,Object? tossDecision = null,Object? matchStatus = null,Object? currentPhase = null,Object? targetScore = freezed,Object? matchResult = freezed,Object? currentStrikerId = freezed,Object? currentNonStrikerId = freezed,Object? currentBowlerId = freezed,Object? createdAt = null,}) {
  return _then(_AppMatch(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,teamAName: null == teamAName ? _self.teamAName : teamAName // ignore: cast_nullable_to_non_nullable
as String,teamBName: null == teamBName ? _self.teamBName : teamBName // ignore: cast_nullable_to_non_nullable
as String,teamAId: freezed == teamAId ? _self.teamAId : teamAId // ignore: cast_nullable_to_non_nullable
as String?,teamBId: freezed == teamBId ? _self.teamBId : teamBId // ignore: cast_nullable_to_non_nullable
as String?,tournamentId: freezed == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String?,sportId: freezed == sportId ? _self.sportId : sportId // ignore: cast_nullable_to_non_nullable
as String?,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as int,tossWinner: null == tossWinner ? _self.tossWinner : tossWinner // ignore: cast_nullable_to_non_nullable
as String,tossDecision: null == tossDecision ? _self.tossDecision : tossDecision // ignore: cast_nullable_to_non_nullable
as String,matchStatus: null == matchStatus ? _self.matchStatus : matchStatus // ignore: cast_nullable_to_non_nullable
as String,currentPhase: null == currentPhase ? _self.currentPhase : currentPhase // ignore: cast_nullable_to_non_nullable
as MatchPhase,targetScore: freezed == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int?,matchResult: freezed == matchResult ? _self.matchResult : matchResult // ignore: cast_nullable_to_non_nullable
as String?,currentStrikerId: freezed == currentStrikerId ? _self.currentStrikerId : currentStrikerId // ignore: cast_nullable_to_non_nullable
as String?,currentNonStrikerId: freezed == currentNonStrikerId ? _self.currentNonStrikerId : currentNonStrikerId // ignore: cast_nullable_to_non_nullable
as String?,currentBowlerId: freezed == currentBowlerId ? _self.currentBowlerId : currentBowlerId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
