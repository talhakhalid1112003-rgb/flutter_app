// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerStats {

 String get playerId; String get playerName; String get matchId; int get runs; int get balls; int get fours; int get sixes; int get wickets; double get oversBowled; int get runsConceded;
/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStatsCopyWith<PlayerStats> get copyWith => _$PlayerStatsCopyWithImpl<PlayerStats>(this as PlayerStats, _$identity);

  /// Serializes this PlayerStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.runs, runs) || other.runs == runs)&&(identical(other.balls, balls) || other.balls == balls)&&(identical(other.fours, fours) || other.fours == fours)&&(identical(other.sixes, sixes) || other.sixes == sixes)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.oversBowled, oversBowled) || other.oversBowled == oversBowled)&&(identical(other.runsConceded, runsConceded) || other.runsConceded == runsConceded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,matchId,runs,balls,fours,sixes,wickets,oversBowled,runsConceded);

@override
String toString() {
  return 'PlayerStats(playerId: $playerId, playerName: $playerName, matchId: $matchId, runs: $runs, balls: $balls, fours: $fours, sixes: $sixes, wickets: $wickets, oversBowled: $oversBowled, runsConceded: $runsConceded)';
}


}

/// @nodoc
abstract mixin class $PlayerStatsCopyWith<$Res>  {
  factory $PlayerStatsCopyWith(PlayerStats value, $Res Function(PlayerStats) _then) = _$PlayerStatsCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, String matchId, int runs, int balls, int fours, int sixes, int wickets, double oversBowled, int runsConceded
});




}
/// @nodoc
class _$PlayerStatsCopyWithImpl<$Res>
    implements $PlayerStatsCopyWith<$Res> {
  _$PlayerStatsCopyWithImpl(this._self, this._then);

  final PlayerStats _self;
  final $Res Function(PlayerStats) _then;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? matchId = null,Object? runs = null,Object? balls = null,Object? fours = null,Object? sixes = null,Object? wickets = null,Object? oversBowled = null,Object? runsConceded = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as int,balls: null == balls ? _self.balls : balls // ignore: cast_nullable_to_non_nullable
as int,fours: null == fours ? _self.fours : fours // ignore: cast_nullable_to_non_nullable
as int,sixes: null == sixes ? _self.sixes : sixes // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,oversBowled: null == oversBowled ? _self.oversBowled : oversBowled // ignore: cast_nullable_to_non_nullable
as double,runsConceded: null == runsConceded ? _self.runsConceded : runsConceded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerStats].
extension PlayerStatsPatterns on PlayerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerStats value)  $default,){
final _that = this;
switch (_that) {
case _PlayerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerStats value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String matchId,  int runs,  int balls,  int fours,  int sixes,  int wickets,  double oversBowled,  int runsConceded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.matchId,_that.runs,_that.balls,_that.fours,_that.sixes,_that.wickets,_that.oversBowled,_that.runsConceded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String matchId,  int runs,  int balls,  int fours,  int sixes,  int wickets,  double oversBowled,  int runsConceded)  $default,) {final _that = this;
switch (_that) {
case _PlayerStats():
return $default(_that.playerId,_that.playerName,_that.matchId,_that.runs,_that.balls,_that.fours,_that.sixes,_that.wickets,_that.oversBowled,_that.runsConceded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  String matchId,  int runs,  int balls,  int fours,  int sixes,  int wickets,  double oversBowled,  int runsConceded)?  $default,) {final _that = this;
switch (_that) {
case _PlayerStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.matchId,_that.runs,_that.balls,_that.fours,_that.sixes,_that.wickets,_that.oversBowled,_that.runsConceded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerStats implements PlayerStats {
  const _PlayerStats({required this.playerId, required this.playerName, required this.matchId, required this.runs, required this.balls, required this.fours, required this.sixes, required this.wickets, required this.oversBowled, required this.runsConceded});
  factory _PlayerStats.fromJson(Map<String, dynamic> json) => _$PlayerStatsFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  String matchId;
@override final  int runs;
@override final  int balls;
@override final  int fours;
@override final  int sixes;
@override final  int wickets;
@override final  double oversBowled;
@override final  int runsConceded;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStatsCopyWith<_PlayerStats> get copyWith => __$PlayerStatsCopyWithImpl<_PlayerStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.runs, runs) || other.runs == runs)&&(identical(other.balls, balls) || other.balls == balls)&&(identical(other.fours, fours) || other.fours == fours)&&(identical(other.sixes, sixes) || other.sixes == sixes)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.oversBowled, oversBowled) || other.oversBowled == oversBowled)&&(identical(other.runsConceded, runsConceded) || other.runsConceded == runsConceded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,matchId,runs,balls,fours,sixes,wickets,oversBowled,runsConceded);

@override
String toString() {
  return 'PlayerStats(playerId: $playerId, playerName: $playerName, matchId: $matchId, runs: $runs, balls: $balls, fours: $fours, sixes: $sixes, wickets: $wickets, oversBowled: $oversBowled, runsConceded: $runsConceded)';
}


}

/// @nodoc
abstract mixin class _$PlayerStatsCopyWith<$Res> implements $PlayerStatsCopyWith<$Res> {
  factory _$PlayerStatsCopyWith(_PlayerStats value, $Res Function(_PlayerStats) _then) = __$PlayerStatsCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, String matchId, int runs, int balls, int fours, int sixes, int wickets, double oversBowled, int runsConceded
});




}
/// @nodoc
class __$PlayerStatsCopyWithImpl<$Res>
    implements _$PlayerStatsCopyWith<$Res> {
  __$PlayerStatsCopyWithImpl(this._self, this._then);

  final _PlayerStats _self;
  final $Res Function(_PlayerStats) _then;

/// Create a copy of PlayerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? matchId = null,Object? runs = null,Object? balls = null,Object? fours = null,Object? sixes = null,Object? wickets = null,Object? oversBowled = null,Object? runsConceded = null,}) {
  return _then(_PlayerStats(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as String,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as int,balls: null == balls ? _self.balls : balls // ignore: cast_nullable_to_non_nullable
as int,fours: null == fours ? _self.fours : fours // ignore: cast_nullable_to_non_nullable
as int,sixes: null == sixes ? _self.sixes : sixes // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,oversBowled: null == oversBowled ? _self.oversBowled : oversBowled // ignore: cast_nullable_to_non_nullable
as double,runsConceded: null == runsConceded ? _self.runsConceded : runsConceded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
