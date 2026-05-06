// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppPlayer {

 String get playerId; String get playerName; String get teamId; String get role;// Batter, Bowler, All-Rounder, Wicket Keeper
 String get battingStyle; String get bowlingStyle;
/// Create a copy of AppPlayer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppPlayerCopyWith<AppPlayer> get copyWith => _$AppPlayerCopyWithImpl<AppPlayer>(this as AppPlayer, _$identity);

  /// Serializes this AppPlayer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppPlayer&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.role, role) || other.role == role)&&(identical(other.battingStyle, battingStyle) || other.battingStyle == battingStyle)&&(identical(other.bowlingStyle, bowlingStyle) || other.bowlingStyle == bowlingStyle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,teamId,role,battingStyle,bowlingStyle);

@override
String toString() {
  return 'AppPlayer(playerId: $playerId, playerName: $playerName, teamId: $teamId, role: $role, battingStyle: $battingStyle, bowlingStyle: $bowlingStyle)';
}


}

/// @nodoc
abstract mixin class $AppPlayerCopyWith<$Res>  {
  factory $AppPlayerCopyWith(AppPlayer value, $Res Function(AppPlayer) _then) = _$AppPlayerCopyWithImpl;
@useResult
$Res call({
 String playerId, String playerName, String teamId, String role, String battingStyle, String bowlingStyle
});




}
/// @nodoc
class _$AppPlayerCopyWithImpl<$Res>
    implements $AppPlayerCopyWith<$Res> {
  _$AppPlayerCopyWithImpl(this._self, this._then);

  final AppPlayer _self;
  final $Res Function(AppPlayer) _then;

/// Create a copy of AppPlayer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? playerId = null,Object? playerName = null,Object? teamId = null,Object? role = null,Object? battingStyle = null,Object? bowlingStyle = null,}) {
  return _then(_self.copyWith(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,battingStyle: null == battingStyle ? _self.battingStyle : battingStyle // ignore: cast_nullable_to_non_nullable
as String,bowlingStyle: null == bowlingStyle ? _self.bowlingStyle : bowlingStyle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppPlayer].
extension AppPlayerPatterns on AppPlayer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppPlayer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppPlayer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppPlayer value)  $default,){
final _that = this;
switch (_that) {
case _AppPlayer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppPlayer value)?  $default,){
final _that = this;
switch (_that) {
case _AppPlayer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String teamId,  String role,  String battingStyle,  String bowlingStyle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppPlayer() when $default != null:
return $default(_that.playerId,_that.playerName,_that.teamId,_that.role,_that.battingStyle,_that.bowlingStyle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String playerId,  String playerName,  String teamId,  String role,  String battingStyle,  String bowlingStyle)  $default,) {final _that = this;
switch (_that) {
case _AppPlayer():
return $default(_that.playerId,_that.playerName,_that.teamId,_that.role,_that.battingStyle,_that.bowlingStyle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String playerId,  String playerName,  String teamId,  String role,  String battingStyle,  String bowlingStyle)?  $default,) {final _that = this;
switch (_that) {
case _AppPlayer() when $default != null:
return $default(_that.playerId,_that.playerName,_that.teamId,_that.role,_that.battingStyle,_that.bowlingStyle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppPlayer implements AppPlayer {
  const _AppPlayer({required this.playerId, required this.playerName, required this.teamId, required this.role, required this.battingStyle, required this.bowlingStyle});
  factory _AppPlayer.fromJson(Map<String, dynamic> json) => _$AppPlayerFromJson(json);

@override final  String playerId;
@override final  String playerName;
@override final  String teamId;
@override final  String role;
// Batter, Bowler, All-Rounder, Wicket Keeper
@override final  String battingStyle;
@override final  String bowlingStyle;

/// Create a copy of AppPlayer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppPlayerCopyWith<_AppPlayer> get copyWith => __$AppPlayerCopyWithImpl<_AppPlayer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppPlayerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPlayer&&(identical(other.playerId, playerId) || other.playerId == playerId)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.role, role) || other.role == role)&&(identical(other.battingStyle, battingStyle) || other.battingStyle == battingStyle)&&(identical(other.bowlingStyle, bowlingStyle) || other.bowlingStyle == bowlingStyle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,playerId,playerName,teamId,role,battingStyle,bowlingStyle);

@override
String toString() {
  return 'AppPlayer(playerId: $playerId, playerName: $playerName, teamId: $teamId, role: $role, battingStyle: $battingStyle, bowlingStyle: $bowlingStyle)';
}


}

/// @nodoc
abstract mixin class _$AppPlayerCopyWith<$Res> implements $AppPlayerCopyWith<$Res> {
  factory _$AppPlayerCopyWith(_AppPlayer value, $Res Function(_AppPlayer) _then) = __$AppPlayerCopyWithImpl;
@override @useResult
$Res call({
 String playerId, String playerName, String teamId, String role, String battingStyle, String bowlingStyle
});




}
/// @nodoc
class __$AppPlayerCopyWithImpl<$Res>
    implements _$AppPlayerCopyWith<$Res> {
  __$AppPlayerCopyWithImpl(this._self, this._then);

  final _AppPlayer _self;
  final $Res Function(_AppPlayer) _then;

/// Create a copy of AppPlayer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? playerId = null,Object? playerName = null,Object? teamId = null,Object? role = null,Object? battingStyle = null,Object? bowlingStyle = null,}) {
  return _then(_AppPlayer(
playerId: null == playerId ? _self.playerId : playerId // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,battingStyle: null == battingStyle ? _self.battingStyle : battingStyle // ignore: cast_nullable_to_non_nullable
as String,bowlingStyle: null == bowlingStyle ? _self.bowlingStyle : bowlingStyle // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
