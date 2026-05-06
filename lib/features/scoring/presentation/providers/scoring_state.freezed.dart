// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scoring_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScoringState {

 String get matchId; String get inningsId; String get strikerId; String get strikerName; String get nonStrikerId; String get nonStrikerName; String get bowlerId; String get bowlerName; int get totalRuns; int get wickets; int get validBallsInOver;// 0 to 6
 int get completedOvers; int get partnershipRuns; int get partnershipBalls; Map<String, BatsmanStats> get batsmanStats; Map<String, BowlerStats> get bowlerStats; bool get isFreeHit; List<AppBall> get currentOverBalls; MatchPhase get currentPhase; int? get targetScore; int? get runsNeeded; int? get ballsRemaining; double? get requiredRunRate; bool get isLoading; String? get error;
/// Create a copy of ScoringState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoringStateCopyWith<ScoringState> get copyWith => _$ScoringStateCopyWithImpl<ScoringState>(this as ScoringState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoringState&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.inningsId, inningsId) || other.inningsId == inningsId)&&(identical(other.strikerId, strikerId) || other.strikerId == strikerId)&&(identical(other.strikerName, strikerName) || other.strikerName == strikerName)&&(identical(other.nonStrikerId, nonStrikerId) || other.nonStrikerId == nonStrikerId)&&(identical(other.nonStrikerName, nonStrikerName) || other.nonStrikerName == nonStrikerName)&&(identical(other.bowlerId, bowlerId) || other.bowlerId == bowlerId)&&(identical(other.bowlerName, bowlerName) || other.bowlerName == bowlerName)&&(identical(other.totalRuns, totalRuns) || other.totalRuns == totalRuns)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.validBallsInOver, validBallsInOver) || other.validBallsInOver == validBallsInOver)&&(identical(other.completedOvers, completedOvers) || other.completedOvers == completedOvers)&&(identical(other.partnershipRuns, partnershipRuns) || other.partnershipRuns == partnershipRuns)&&(identical(other.partnershipBalls, partnershipBalls) || other.partnershipBalls == partnershipBalls)&&const DeepCollectionEquality().equals(other.batsmanStats, batsmanStats)&&const DeepCollectionEquality().equals(other.bowlerStats, bowlerStats)&&(identical(other.isFreeHit, isFreeHit) || other.isFreeHit == isFreeHit)&&const DeepCollectionEquality().equals(other.currentOverBalls, currentOverBalls)&&(identical(other.currentPhase, currentPhase) || other.currentPhase == currentPhase)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.runsNeeded, runsNeeded) || other.runsNeeded == runsNeeded)&&(identical(other.ballsRemaining, ballsRemaining) || other.ballsRemaining == ballsRemaining)&&(identical(other.requiredRunRate, requiredRunRate) || other.requiredRunRate == requiredRunRate)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hashAll([runtimeType,matchId,inningsId,strikerId,strikerName,nonStrikerId,nonStrikerName,bowlerId,bowlerName,totalRuns,wickets,validBallsInOver,completedOvers,partnershipRuns,partnershipBalls,const DeepCollectionEquality().hash(batsmanStats),const DeepCollectionEquality().hash(bowlerStats),isFreeHit,const DeepCollectionEquality().hash(currentOverBalls),currentPhase,targetScore,runsNeeded,ballsRemaining,requiredRunRate,isLoading,error]);

@override
String toString() {
  return 'ScoringState(matchId: $matchId, inningsId: $inningsId, strikerId: $strikerId, strikerName: $strikerName, nonStrikerId: $nonStrikerId, nonStrikerName: $nonStrikerName, bowlerId: $bowlerId, bowlerName: $bowlerName, totalRuns: $totalRuns, wickets: $wickets, validBallsInOver: $validBallsInOver, completedOvers: $completedOvers, partnershipRuns: $partnershipRuns, partnershipBalls: $partnershipBalls, batsmanStats: $batsmanStats, bowlerStats: $bowlerStats, isFreeHit: $isFreeHit, currentOverBalls: $currentOverBalls, currentPhase: $currentPhase, targetScore: $targetScore, runsNeeded: $runsNeeded, ballsRemaining: $ballsRemaining, requiredRunRate: $requiredRunRate, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $ScoringStateCopyWith<$Res>  {
  factory $ScoringStateCopyWith(ScoringState value, $Res Function(ScoringState) _then) = _$ScoringStateCopyWithImpl;
@useResult
$Res call({
 String matchId, String inningsId, String strikerId, String strikerName, String nonStrikerId, String nonStrikerName, String bowlerId, String bowlerName, int totalRuns, int wickets, int validBallsInOver, int completedOvers, int partnershipRuns, int partnershipBalls, Map<String, BatsmanStats> batsmanStats, Map<String, BowlerStats> bowlerStats, bool isFreeHit, List<AppBall> currentOverBalls, MatchPhase currentPhase, int? targetScore, int? runsNeeded, int? ballsRemaining, double? requiredRunRate, bool isLoading, String? error
});




}
/// @nodoc
class _$ScoringStateCopyWithImpl<$Res>
    implements $ScoringStateCopyWith<$Res> {
  _$ScoringStateCopyWithImpl(this._self, this._then);

  final ScoringState _self;
  final $Res Function(ScoringState) _then;

/// Create a copy of ScoringState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matchId = null,Object? inningsId = null,Object? strikerId = null,Object? strikerName = null,Object? nonStrikerId = null,Object? nonStrikerName = null,Object? bowlerId = null,Object? bowlerName = null,Object? totalRuns = null,Object? wickets = null,Object? validBallsInOver = null,Object? completedOvers = null,Object? partnershipRuns = null,Object? partnershipBalls = null,Object? batsmanStats = null,Object? bowlerStats = null,Object? isFreeHit = null,Object? currentOverBalls = null,Object? currentPhase = null,Object? targetScore = freezed,Object? runsNeeded = freezed,Object? ballsRemaining = freezed,Object? requiredRunRate = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,inningsId: null == inningsId ? _self.inningsId : inningsId // ignore: cast_nullable_to_non_nullable
as String,strikerId: null == strikerId ? _self.strikerId : strikerId // ignore: cast_nullable_to_non_nullable
as String,strikerName: null == strikerName ? _self.strikerName : strikerName // ignore: cast_nullable_to_non_nullable
as String,nonStrikerId: null == nonStrikerId ? _self.nonStrikerId : nonStrikerId // ignore: cast_nullable_to_non_nullable
as String,nonStrikerName: null == nonStrikerName ? _self.nonStrikerName : nonStrikerName // ignore: cast_nullable_to_non_nullable
as String,bowlerId: null == bowlerId ? _self.bowlerId : bowlerId // ignore: cast_nullable_to_non_nullable
as String,bowlerName: null == bowlerName ? _self.bowlerName : bowlerName // ignore: cast_nullable_to_non_nullable
as String,totalRuns: null == totalRuns ? _self.totalRuns : totalRuns // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,validBallsInOver: null == validBallsInOver ? _self.validBallsInOver : validBallsInOver // ignore: cast_nullable_to_non_nullable
as int,completedOvers: null == completedOvers ? _self.completedOvers : completedOvers // ignore: cast_nullable_to_non_nullable
as int,partnershipRuns: null == partnershipRuns ? _self.partnershipRuns : partnershipRuns // ignore: cast_nullable_to_non_nullable
as int,partnershipBalls: null == partnershipBalls ? _self.partnershipBalls : partnershipBalls // ignore: cast_nullable_to_non_nullable
as int,batsmanStats: null == batsmanStats ? _self.batsmanStats : batsmanStats // ignore: cast_nullable_to_non_nullable
as Map<String, BatsmanStats>,bowlerStats: null == bowlerStats ? _self.bowlerStats : bowlerStats // ignore: cast_nullable_to_non_nullable
as Map<String, BowlerStats>,isFreeHit: null == isFreeHit ? _self.isFreeHit : isFreeHit // ignore: cast_nullable_to_non_nullable
as bool,currentOverBalls: null == currentOverBalls ? _self.currentOverBalls : currentOverBalls // ignore: cast_nullable_to_non_nullable
as List<AppBall>,currentPhase: null == currentPhase ? _self.currentPhase : currentPhase // ignore: cast_nullable_to_non_nullable
as MatchPhase,targetScore: freezed == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int?,runsNeeded: freezed == runsNeeded ? _self.runsNeeded : runsNeeded // ignore: cast_nullable_to_non_nullable
as int?,ballsRemaining: freezed == ballsRemaining ? _self.ballsRemaining : ballsRemaining // ignore: cast_nullable_to_non_nullable
as int?,requiredRunRate: freezed == requiredRunRate ? _self.requiredRunRate : requiredRunRate // ignore: cast_nullable_to_non_nullable
as double?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoringState].
extension ScoringStatePatterns on ScoringState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoringState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoringState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoringState value)  $default,){
final _that = this;
switch (_that) {
case _ScoringState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoringState value)?  $default,){
final _that = this;
switch (_that) {
case _ScoringState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String matchId,  String inningsId,  String strikerId,  String strikerName,  String nonStrikerId,  String nonStrikerName,  String bowlerId,  String bowlerName,  int totalRuns,  int wickets,  int validBallsInOver,  int completedOvers,  int partnershipRuns,  int partnershipBalls,  Map<String, BatsmanStats> batsmanStats,  Map<String, BowlerStats> bowlerStats,  bool isFreeHit,  List<AppBall> currentOverBalls,  MatchPhase currentPhase,  int? targetScore,  int? runsNeeded,  int? ballsRemaining,  double? requiredRunRate,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoringState() when $default != null:
return $default(_that.matchId,_that.inningsId,_that.strikerId,_that.strikerName,_that.nonStrikerId,_that.nonStrikerName,_that.bowlerId,_that.bowlerName,_that.totalRuns,_that.wickets,_that.validBallsInOver,_that.completedOvers,_that.partnershipRuns,_that.partnershipBalls,_that.batsmanStats,_that.bowlerStats,_that.isFreeHit,_that.currentOverBalls,_that.currentPhase,_that.targetScore,_that.runsNeeded,_that.ballsRemaining,_that.requiredRunRate,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String matchId,  String inningsId,  String strikerId,  String strikerName,  String nonStrikerId,  String nonStrikerName,  String bowlerId,  String bowlerName,  int totalRuns,  int wickets,  int validBallsInOver,  int completedOvers,  int partnershipRuns,  int partnershipBalls,  Map<String, BatsmanStats> batsmanStats,  Map<String, BowlerStats> bowlerStats,  bool isFreeHit,  List<AppBall> currentOverBalls,  MatchPhase currentPhase,  int? targetScore,  int? runsNeeded,  int? ballsRemaining,  double? requiredRunRate,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ScoringState():
return $default(_that.matchId,_that.inningsId,_that.strikerId,_that.strikerName,_that.nonStrikerId,_that.nonStrikerName,_that.bowlerId,_that.bowlerName,_that.totalRuns,_that.wickets,_that.validBallsInOver,_that.completedOvers,_that.partnershipRuns,_that.partnershipBalls,_that.batsmanStats,_that.bowlerStats,_that.isFreeHit,_that.currentOverBalls,_that.currentPhase,_that.targetScore,_that.runsNeeded,_that.ballsRemaining,_that.requiredRunRate,_that.isLoading,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String matchId,  String inningsId,  String strikerId,  String strikerName,  String nonStrikerId,  String nonStrikerName,  String bowlerId,  String bowlerName,  int totalRuns,  int wickets,  int validBallsInOver,  int completedOvers,  int partnershipRuns,  int partnershipBalls,  Map<String, BatsmanStats> batsmanStats,  Map<String, BowlerStats> bowlerStats,  bool isFreeHit,  List<AppBall> currentOverBalls,  MatchPhase currentPhase,  int? targetScore,  int? runsNeeded,  int? ballsRemaining,  double? requiredRunRate,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ScoringState() when $default != null:
return $default(_that.matchId,_that.inningsId,_that.strikerId,_that.strikerName,_that.nonStrikerId,_that.nonStrikerName,_that.bowlerId,_that.bowlerName,_that.totalRuns,_that.wickets,_that.validBallsInOver,_that.completedOvers,_that.partnershipRuns,_that.partnershipBalls,_that.batsmanStats,_that.bowlerStats,_that.isFreeHit,_that.currentOverBalls,_that.currentPhase,_that.targetScore,_that.runsNeeded,_that.ballsRemaining,_that.requiredRunRate,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ScoringState implements ScoringState {
  const _ScoringState({required this.matchId, required this.inningsId, required this.strikerId, required this.strikerName, required this.nonStrikerId, required this.nonStrikerName, required this.bowlerId, required this.bowlerName, required this.totalRuns, required this.wickets, required this.validBallsInOver, required this.completedOvers, this.partnershipRuns = 0, this.partnershipBalls = 0, final  Map<String, BatsmanStats> batsmanStats = const {}, final  Map<String, BowlerStats> bowlerStats = const {}, this.isFreeHit = false, final  List<AppBall> currentOverBalls = const [], this.currentPhase = MatchPhase.initial, this.targetScore, this.runsNeeded, this.ballsRemaining, this.requiredRunRate, this.isLoading = false, this.error}): _batsmanStats = batsmanStats,_bowlerStats = bowlerStats,_currentOverBalls = currentOverBalls;
  

@override final  String matchId;
@override final  String inningsId;
@override final  String strikerId;
@override final  String strikerName;
@override final  String nonStrikerId;
@override final  String nonStrikerName;
@override final  String bowlerId;
@override final  String bowlerName;
@override final  int totalRuns;
@override final  int wickets;
@override final  int validBallsInOver;
// 0 to 6
@override final  int completedOvers;
@override@JsonKey() final  int partnershipRuns;
@override@JsonKey() final  int partnershipBalls;
 final  Map<String, BatsmanStats> _batsmanStats;
@override@JsonKey() Map<String, BatsmanStats> get batsmanStats {
  if (_batsmanStats is EqualUnmodifiableMapView) return _batsmanStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_batsmanStats);
}

 final  Map<String, BowlerStats> _bowlerStats;
@override@JsonKey() Map<String, BowlerStats> get bowlerStats {
  if (_bowlerStats is EqualUnmodifiableMapView) return _bowlerStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_bowlerStats);
}

@override@JsonKey() final  bool isFreeHit;
 final  List<AppBall> _currentOverBalls;
@override@JsonKey() List<AppBall> get currentOverBalls {
  if (_currentOverBalls is EqualUnmodifiableListView) return _currentOverBalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_currentOverBalls);
}

@override@JsonKey() final  MatchPhase currentPhase;
@override final  int? targetScore;
@override final  int? runsNeeded;
@override final  int? ballsRemaining;
@override final  double? requiredRunRate;
@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of ScoringState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoringStateCopyWith<_ScoringState> get copyWith => __$ScoringStateCopyWithImpl<_ScoringState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoringState&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.inningsId, inningsId) || other.inningsId == inningsId)&&(identical(other.strikerId, strikerId) || other.strikerId == strikerId)&&(identical(other.strikerName, strikerName) || other.strikerName == strikerName)&&(identical(other.nonStrikerId, nonStrikerId) || other.nonStrikerId == nonStrikerId)&&(identical(other.nonStrikerName, nonStrikerName) || other.nonStrikerName == nonStrikerName)&&(identical(other.bowlerId, bowlerId) || other.bowlerId == bowlerId)&&(identical(other.bowlerName, bowlerName) || other.bowlerName == bowlerName)&&(identical(other.totalRuns, totalRuns) || other.totalRuns == totalRuns)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.validBallsInOver, validBallsInOver) || other.validBallsInOver == validBallsInOver)&&(identical(other.completedOvers, completedOvers) || other.completedOvers == completedOvers)&&(identical(other.partnershipRuns, partnershipRuns) || other.partnershipRuns == partnershipRuns)&&(identical(other.partnershipBalls, partnershipBalls) || other.partnershipBalls == partnershipBalls)&&const DeepCollectionEquality().equals(other._batsmanStats, _batsmanStats)&&const DeepCollectionEquality().equals(other._bowlerStats, _bowlerStats)&&(identical(other.isFreeHit, isFreeHit) || other.isFreeHit == isFreeHit)&&const DeepCollectionEquality().equals(other._currentOverBalls, _currentOverBalls)&&(identical(other.currentPhase, currentPhase) || other.currentPhase == currentPhase)&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.runsNeeded, runsNeeded) || other.runsNeeded == runsNeeded)&&(identical(other.ballsRemaining, ballsRemaining) || other.ballsRemaining == ballsRemaining)&&(identical(other.requiredRunRate, requiredRunRate) || other.requiredRunRate == requiredRunRate)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hashAll([runtimeType,matchId,inningsId,strikerId,strikerName,nonStrikerId,nonStrikerName,bowlerId,bowlerName,totalRuns,wickets,validBallsInOver,completedOvers,partnershipRuns,partnershipBalls,const DeepCollectionEquality().hash(_batsmanStats),const DeepCollectionEquality().hash(_bowlerStats),isFreeHit,const DeepCollectionEquality().hash(_currentOverBalls),currentPhase,targetScore,runsNeeded,ballsRemaining,requiredRunRate,isLoading,error]);

@override
String toString() {
  return 'ScoringState(matchId: $matchId, inningsId: $inningsId, strikerId: $strikerId, strikerName: $strikerName, nonStrikerId: $nonStrikerId, nonStrikerName: $nonStrikerName, bowlerId: $bowlerId, bowlerName: $bowlerName, totalRuns: $totalRuns, wickets: $wickets, validBallsInOver: $validBallsInOver, completedOvers: $completedOvers, partnershipRuns: $partnershipRuns, partnershipBalls: $partnershipBalls, batsmanStats: $batsmanStats, bowlerStats: $bowlerStats, isFreeHit: $isFreeHit, currentOverBalls: $currentOverBalls, currentPhase: $currentPhase, targetScore: $targetScore, runsNeeded: $runsNeeded, ballsRemaining: $ballsRemaining, requiredRunRate: $requiredRunRate, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ScoringStateCopyWith<$Res> implements $ScoringStateCopyWith<$Res> {
  factory _$ScoringStateCopyWith(_ScoringState value, $Res Function(_ScoringState) _then) = __$ScoringStateCopyWithImpl;
@override @useResult
$Res call({
 String matchId, String inningsId, String strikerId, String strikerName, String nonStrikerId, String nonStrikerName, String bowlerId, String bowlerName, int totalRuns, int wickets, int validBallsInOver, int completedOvers, int partnershipRuns, int partnershipBalls, Map<String, BatsmanStats> batsmanStats, Map<String, BowlerStats> bowlerStats, bool isFreeHit, List<AppBall> currentOverBalls, MatchPhase currentPhase, int? targetScore, int? runsNeeded, int? ballsRemaining, double? requiredRunRate, bool isLoading, String? error
});




}
/// @nodoc
class __$ScoringStateCopyWithImpl<$Res>
    implements _$ScoringStateCopyWith<$Res> {
  __$ScoringStateCopyWithImpl(this._self, this._then);

  final _ScoringState _self;
  final $Res Function(_ScoringState) _then;

/// Create a copy of ScoringState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matchId = null,Object? inningsId = null,Object? strikerId = null,Object? strikerName = null,Object? nonStrikerId = null,Object? nonStrikerName = null,Object? bowlerId = null,Object? bowlerName = null,Object? totalRuns = null,Object? wickets = null,Object? validBallsInOver = null,Object? completedOvers = null,Object? partnershipRuns = null,Object? partnershipBalls = null,Object? batsmanStats = null,Object? bowlerStats = null,Object? isFreeHit = null,Object? currentOverBalls = null,Object? currentPhase = null,Object? targetScore = freezed,Object? runsNeeded = freezed,Object? ballsRemaining = freezed,Object? requiredRunRate = freezed,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_ScoringState(
matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,inningsId: null == inningsId ? _self.inningsId : inningsId // ignore: cast_nullable_to_non_nullable
as String,strikerId: null == strikerId ? _self.strikerId : strikerId // ignore: cast_nullable_to_non_nullable
as String,strikerName: null == strikerName ? _self.strikerName : strikerName // ignore: cast_nullable_to_non_nullable
as String,nonStrikerId: null == nonStrikerId ? _self.nonStrikerId : nonStrikerId // ignore: cast_nullable_to_non_nullable
as String,nonStrikerName: null == nonStrikerName ? _self.nonStrikerName : nonStrikerName // ignore: cast_nullable_to_non_nullable
as String,bowlerId: null == bowlerId ? _self.bowlerId : bowlerId // ignore: cast_nullable_to_non_nullable
as String,bowlerName: null == bowlerName ? _self.bowlerName : bowlerName // ignore: cast_nullable_to_non_nullable
as String,totalRuns: null == totalRuns ? _self.totalRuns : totalRuns // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,validBallsInOver: null == validBallsInOver ? _self.validBallsInOver : validBallsInOver // ignore: cast_nullable_to_non_nullable
as int,completedOvers: null == completedOvers ? _self.completedOvers : completedOvers // ignore: cast_nullable_to_non_nullable
as int,partnershipRuns: null == partnershipRuns ? _self.partnershipRuns : partnershipRuns // ignore: cast_nullable_to_non_nullable
as int,partnershipBalls: null == partnershipBalls ? _self.partnershipBalls : partnershipBalls // ignore: cast_nullable_to_non_nullable
as int,batsmanStats: null == batsmanStats ? _self._batsmanStats : batsmanStats // ignore: cast_nullable_to_non_nullable
as Map<String, BatsmanStats>,bowlerStats: null == bowlerStats ? _self._bowlerStats : bowlerStats // ignore: cast_nullable_to_non_nullable
as Map<String, BowlerStats>,isFreeHit: null == isFreeHit ? _self.isFreeHit : isFreeHit // ignore: cast_nullable_to_non_nullable
as bool,currentOverBalls: null == currentOverBalls ? _self._currentOverBalls : currentOverBalls // ignore: cast_nullable_to_non_nullable
as List<AppBall>,currentPhase: null == currentPhase ? _self.currentPhase : currentPhase // ignore: cast_nullable_to_non_nullable
as MatchPhase,targetScore: freezed == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int?,runsNeeded: freezed == runsNeeded ? _self.runsNeeded : runsNeeded // ignore: cast_nullable_to_non_nullable
as int?,ballsRemaining: freezed == ballsRemaining ? _self.ballsRemaining : ballsRemaining // ignore: cast_nullable_to_non_nullable
as int?,requiredRunRate: freezed == requiredRunRate ? _self.requiredRunRate : requiredRunRate // ignore: cast_nullable_to_non_nullable
as double?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
