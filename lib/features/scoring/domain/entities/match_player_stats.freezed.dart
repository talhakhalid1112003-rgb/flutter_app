// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_player_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BatsmanStats {

 String get playerId; String get playerName; int get runs; int get ballsFaced; int get fours; int get sixes; double get strikeRate; bool get isOut; int get boundaries;
/// Create a copy of BatsmanStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BatsmanStatsCopyWith<BatsmanStats> get copyWith => _$BatsmanStatsCopyWithImpl<BatsmanStats>(this as BatsmanStats, _$identity);

  /// Serializes this BatsmanStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BatsmanStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.runs, runs) || other.runs == runs)&&(identical(other.ballsFaced, ballsFaced) || other.ballsFaced == ballsFaced)&&(identical(other.fours, fours) || other.fours == fours)&&(identical(other.sixes, sixes) || other.sixes == sixes)&&(identical(other.strikeRate, strikeRate) || other.strikeRate == strikeRate)&&(identical(other.isOut, isOut) || other.isOut == isOut)&&(identical(other.boundaries, boundaries) || other.boundaries == boundaries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,runs,ballsFaced,fours,sixes,strikeRate,isOut,boundaries);

@override
String toString() {
  return 'BatsmanStats(playerId: $playerId, playerName: $playerName, runs: $runs, ballsFaced: $ballsFaced, fours: $fours, sixes: $sixes, strikeRate: $strikeRate, isOut: $isOut, boundaries: $boundaries)';
}


}

/// @nodoc
abstract mixin class $BatsmanStatsCopyWith<$Res>  {
  factory $BatsmanStatsCopyWith(BatsmanStats value, $Res Function(BatsmanStats) _then) = _$BatsmanStatsCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, int runs, int ballsFaced, int fours, int sixes, double strikeRate, bool isOut, int boundaries
});




}
/// @nodoc
class _$BatsmanStatsCopyWithImpl<$Res>
    implements $BatsmanStatsCopyWith<$Res> {
  _$BatsmanStatsCopyWithImpl(this._self, this._then);

  final BatsmanStats _self;
  final $Res Function(BatsmanStats) _then;

/// Create a copy of BatsmanStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? runs = null,Object? ballsFaced = null,Object? fours = null,Object? sixes = null,Object? strikeRate = null,Object? isOut = null,Object? boundaries = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as int,ballsFaced: null == ballsFaced ? _self.ballsFaced : ballsFaced // ignore: cast_nullable_to_non_nullable
as int,fours: null == fours ? _self.fours : fours // ignore: cast_nullable_to_non_nullable
as int,sixes: null == sixes ? _self.sixes : sixes // ignore: cast_nullable_to_non_nullable
as int,strikeRate: null == strikeRate ? _self.strikeRate : strikeRate // ignore: cast_nullable_to_non_nullable
as double,isOut: null == isOut ? _self.isOut : isOut // ignore: cast_nullable_to_non_nullable
as bool,boundaries: null == boundaries ? _self.boundaries : boundaries // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BatsmanStats].
extension BatsmanStatsPatterns on BatsmanStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BatsmanStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BatsmanStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BatsmanStats value)  $default,){
final _that = this;
switch (_that) {
case _BatsmanStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BatsmanStats value)?  $default,){
final _that = this;
switch (_that) {
case _BatsmanStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int runs,  int ballsFaced,  int fours,  int sixes,  double strikeRate,  bool isOut,  int boundaries)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BatsmanStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.runs,_that.ballsFaced,_that.fours,_that.sixes,_that.strikeRate,_that.isOut,_that.boundaries);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int runs,  int ballsFaced,  int fours,  int sixes,  double strikeRate,  bool isOut,  int boundaries)  $default,) {final _that = this;
switch (_that) {
case _BatsmanStats():
return $default(_that.playerId,_that.playerName,_that.runs,_that.ballsFaced,_that.fours,_that.sixes,_that.strikeRate,_that.isOut,_that.boundaries);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  int runs,  int ballsFaced,  int fours,  int sixes,  double strikeRate,  bool isOut,  int boundaries)?  $default,) {final _that = this;
switch (_that) {
case _BatsmanStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.runs,_that.ballsFaced,_that.fours,_that.sixes,_that.strikeRate,_that.isOut,_that.boundaries);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BatsmanStats extends BatsmanStats {
  const _BatsmanStats({required this.playerId, required this.playerName, required this.runs, required this.ballsFaced, required this.fours, required this.sixes, required this.strikeRate, required this.isOut, this.boundaries = 0}): super._();
  factory _BatsmanStats.fromJson(Map<String, dynamic> json) => _$BatsmanStatsFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  int runs;
@override final  int ballsFaced;
@override final  int fours;
@override final  int sixes;
@override final  double strikeRate;
@override final  bool isOut;
@override@JsonKey() final  int boundaries;

/// Create a copy of BatsmanStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BatsmanStatsCopyWith<_BatsmanStats> get copyWith => __$BatsmanStatsCopyWithImpl<_BatsmanStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BatsmanStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BatsmanStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.runs, runs) || other.runs == runs)&&(identical(other.ballsFaced, ballsFaced) || other.ballsFaced == ballsFaced)&&(identical(other.fours, fours) || other.fours == fours)&&(identical(other.sixes, sixes) || other.sixes == sixes)&&(identical(other.strikeRate, strikeRate) || other.strikeRate == strikeRate)&&(identical(other.isOut, isOut) || other.isOut == isOut)&&(identical(other.boundaries, boundaries) || other.boundaries == boundaries));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,runs,ballsFaced,fours,sixes,strikeRate,isOut,boundaries);

@override
String toString() {
  return 'BatsmanStats(playerId: $playerId, playerName: $playerName, runs: $runs, ballsFaced: $ballsFaced, fours: $fours, sixes: $sixes, strikeRate: $strikeRate, isOut: $isOut, boundaries: $boundaries)';
}


}

/// @nodoc
abstract mixin class _$BatsmanStatsCopyWith<$Res> implements $BatsmanStatsCopyWith<$Res> {
  factory _$BatsmanStatsCopyWith(_BatsmanStats value, $Res Function(_BatsmanStats) _then) = __$BatsmanStatsCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, int runs, int ballsFaced, int fours, int sixes, double strikeRate, bool isOut, int boundaries
});




}
/// @nodoc
class __$BatsmanStatsCopyWithImpl<$Res>
    implements _$BatsmanStatsCopyWith<$Res> {
  __$BatsmanStatsCopyWithImpl(this._self, this._then);

  final _BatsmanStats _self;
  final $Res Function(_BatsmanStats) _then;

/// Create a copy of BatsmanStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? runs = null,Object? ballsFaced = null,Object? fours = null,Object? sixes = null,Object? strikeRate = null,Object? isOut = null,Object? boundaries = null,}) {
  return _then(_BatsmanStats(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,runs: null == runs ? _self.runs : runs // ignore: cast_nullable_to_non_nullable
as int,ballsFaced: null == ballsFaced ? _self.ballsFaced : ballsFaced // ignore: cast_nullable_to_non_nullable
as int,fours: null == fours ? _self.fours : fours // ignore: cast_nullable_to_non_nullable
as int,sixes: null == sixes ? _self.sixes : sixes // ignore: cast_nullable_to_non_nullable
as int,strikeRate: null == strikeRate ? _self.strikeRate : strikeRate // ignore: cast_nullable_to_non_nullable
as double,isOut: null == isOut ? _self.isOut : isOut // ignore: cast_nullable_to_non_nullable
as bool,boundaries: null == boundaries ? _self.boundaries : boundaries // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BowlerStats {

 String get playerId; String get playerName; int get ballsBowled; double get overs; int get runsConceded; int get wickets; int get maidens; int get dotBalls; double get economy;
/// Create a copy of BowlerStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BowlerStatsCopyWith<BowlerStats> get copyWith => _$BowlerStatsCopyWithImpl<BowlerStats>(this as BowlerStats, _$identity);

  /// Serializes this BowlerStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BowlerStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.ballsBowled, ballsBowled) || other.ballsBowled == ballsBowled)&&(identical(other.overs, overs) || other.overs == overs)&&(identical(other.runsConceded, runsConceded) || other.runsConceded == runsConceded)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.maidens, maidens) || other.maidens == maidens)&&(identical(other.dotBalls, dotBalls) || other.dotBalls == dotBalls)&&(identical(other.economy, economy) || other.economy == economy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,ballsBowled,overs,runsConceded,wickets,maidens,dotBalls,economy);

@override
String toString() {
  return 'BowlerStats(playerId: $playerId, playerName: $playerName, ballsBowled: $ballsBowled, overs: $overs, runsConceded: $runsConceded, wickets: $wickets, maidens: $maidens, dotBalls: $dotBalls, economy: $economy)';
}


}

/// @nodoc
abstract mixin class $BowlerStatsCopyWith<$Res>  {
  factory $BowlerStatsCopyWith(BowlerStats value, $Res Function(BowlerStats) _then) = _$BowlerStatsCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, int ballsBowled, double overs, int runsConceded, int wickets, int maidens, int dotBalls, double economy
});




}
/// @nodoc
class _$BowlerStatsCopyWithImpl<$Res>
    implements $BowlerStatsCopyWith<$Res> {
  _$BowlerStatsCopyWithImpl(this._self, this._then);

  final BowlerStats _self;
  final $Res Function(BowlerStats) _then;

/// Create a copy of BowlerStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? ballsBowled = null,Object? overs = null,Object? runsConceded = null,Object? wickets = null,Object? maidens = null,Object? dotBalls = null,Object? economy = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,ballsBowled: null == ballsBowled ? _self.ballsBowled : ballsBowled // ignore: cast_nullable_to_non_nullable
as int,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as double,runsConceded: null == runsConceded ? _self.runsConceded : runsConceded // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,maidens: null == maidens ? _self.maidens : maidens // ignore: cast_nullable_to_non_nullable
as int,dotBalls: null == dotBalls ? _self.dotBalls : dotBalls // ignore: cast_nullable_to_non_nullable
as int,economy: null == economy ? _self.economy : economy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [BowlerStats].
extension BowlerStatsPatterns on BowlerStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BowlerStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BowlerStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BowlerStats value)  $default,){
final _that = this;
switch (_that) {
case _BowlerStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BowlerStats value)?  $default,){
final _that = this;
switch (_that) {
case _BowlerStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int ballsBowled,  double overs,  int runsConceded,  int wickets,  int maidens,  int dotBalls,  double economy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BowlerStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.ballsBowled,_that.overs,_that.runsConceded,_that.wickets,_that.maidens,_that.dotBalls,_that.economy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  int ballsBowled,  double overs,  int runsConceded,  int wickets,  int maidens,  int dotBalls,  double economy)  $default,) {final _that = this;
switch (_that) {
case _BowlerStats():
return $default(_that.playerId,_that.playerName,_that.ballsBowled,_that.overs,_that.runsConceded,_that.wickets,_that.maidens,_that.dotBalls,_that.economy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  int ballsBowled,  double overs,  int runsConceded,  int wickets,  int maidens,  int dotBalls,  double economy)?  $default,) {final _that = this;
switch (_that) {
case _BowlerStats() when $default != null:
return $default(_that.playerId,_that.playerName,_that.ballsBowled,_that.overs,_that.runsConceded,_that.wickets,_that.maidens,_that.dotBalls,_that.economy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BowlerStats extends BowlerStats {
  const _BowlerStats({required this.playerId, required this.playerName, required this.ballsBowled, required this.overs, required this.runsConceded, required this.wickets, required this.maidens, required this.dotBalls, required this.economy}): super._();
  factory _BowlerStats.fromJson(Map<String, dynamic> json) => _$BowlerStatsFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  int ballsBowled;
@override final  double overs;
@override final  int runsConceded;
@override final  int wickets;
@override final  int maidens;
@override final  int dotBalls;
@override final  double economy;

/// Create a copy of BowlerStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BowlerStatsCopyWith<_BowlerStats> get copyWith => __$BowlerStatsCopyWithImpl<_BowlerStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BowlerStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BowlerStats&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.ballsBowled, ballsBowled) || other.ballsBowled == ballsBowled)&&(identical(other.overs, overs) || other.overs == overs)&&(identical(other.runsConceded, runsConceded) || other.runsConceded == runsConceded)&&(identical(other.wickets, wickets) || other.wickets == wickets)&&(identical(other.maidens, maidens) || other.maidens == maidens)&&(identical(other.dotBalls, dotBalls) || other.dotBalls == dotBalls)&&(identical(other.economy, economy) || other.economy == economy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,ballsBowled,overs,runsConceded,wickets,maidens,dotBalls,economy);

@override
String toString() {
  return 'BowlerStats(playerId: $playerId, playerName: $playerName, ballsBowled: $ballsBowled, overs: $overs, runsConceded: $runsConceded, wickets: $wickets, maidens: $maidens, dotBalls: $dotBalls, economy: $economy)';
}


}

/// @nodoc
abstract mixin class _$BowlerStatsCopyWith<$Res> implements $BowlerStatsCopyWith<$Res> {
  factory _$BowlerStatsCopyWith(_BowlerStats value, $Res Function(_BowlerStats) _then) = __$BowlerStatsCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, int ballsBowled, double overs, int runsConceded, int wickets, int maidens, int dotBalls, double economy
});




}
/// @nodoc
class __$BowlerStatsCopyWithImpl<$Res>
    implements _$BowlerStatsCopyWith<$Res> {
  __$BowlerStatsCopyWithImpl(this._self, this._then);

  final _BowlerStats _self;
  final $Res Function(_BowlerStats) _then;

/// Create a copy of BowlerStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? ballsBowled = null,Object? overs = null,Object? runsConceded = null,Object? wickets = null,Object? maidens = null,Object? dotBalls = null,Object? economy = null,}) {
  return _then(_BowlerStats(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,ballsBowled: null == ballsBowled ? _self.ballsBowled : ballsBowled // ignore: cast_nullable_to_non_nullable
as int,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as double,runsConceded: null == runsConceded ? _self.runsConceded : runsConceded // ignore: cast_nullable_to_non_nullable
as int,wickets: null == wickets ? _self.wickets : wickets // ignore: cast_nullable_to_non_nullable
as int,maidens: null == maidens ? _self.maidens : maidens // ignore: cast_nullable_to_non_nullable
as int,dotBalls: null == dotBalls ? _self.dotBalls : dotBalls // ignore: cast_nullable_to_non_nullable
as int,economy: null == economy ? _self.economy : economy // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
