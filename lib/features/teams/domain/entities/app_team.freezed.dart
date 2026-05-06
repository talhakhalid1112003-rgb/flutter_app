// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppTeam {

 String get teamId; String get teamName; String get createdBy;
/// Create a copy of AppTeam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppTeamCopyWith<AppTeam> get copyWith => _$AppTeamCopyWithImpl<AppTeam>(this as AppTeam, _$identity);

  /// Serializes this AppTeam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppTeam&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamId,teamName,createdBy);

@override
String toString() {
  return 'AppTeam(teamId: $teamId, teamName: $teamName, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class $AppTeamCopyWith<$Res>  {
  factory $AppTeamCopyWith(AppTeam value, $Res Function(AppTeam) _then) = _$AppTeamCopyWithImpl;
@useResult
$Res call({
 String teamId, String teamName, String createdBy
});




}
/// @nodoc
class _$AppTeamCopyWithImpl<$Res>
    implements $AppTeamCopyWith<$Res> {
  _$AppTeamCopyWithImpl(this._self, this._then);

  final AppTeam _self;
  final $Res Function(AppTeam) _then;

/// Create a copy of AppTeam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? teamName = null,Object? createdBy = null,}) {
  return _then(_self.copyWith(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppTeam].
extension AppTeamPatterns on AppTeam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppTeam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppTeam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppTeam value)  $default,){
final _that = this;
switch (_that) {
case _AppTeam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppTeam value)?  $default,){
final _that = this;
switch (_that) {
case _AppTeam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teamId,  String teamName,  String createdBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppTeam() when $default != null:
return $default(_that.teamId,_that.teamName,_that.createdBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teamId,  String teamName,  String createdBy)  $default,) {final _that = this;
switch (_that) {
case _AppTeam():
return $default(_that.teamId,_that.teamName,_that.createdBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teamId,  String teamName,  String createdBy)?  $default,) {final _that = this;
switch (_that) {
case _AppTeam() when $default != null:
return $default(_that.teamId,_that.teamName,_that.createdBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppTeam implements AppTeam {
  const _AppTeam({required this.teamId, required this.teamName, required this.createdBy});
  factory _AppTeam.fromJson(Map<String, dynamic> json) => _$AppTeamFromJson(json);

@override final  String teamId;
@override final  String teamName;
@override final  String createdBy;

/// Create a copy of AppTeam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppTeamCopyWith<_AppTeam> get copyWith => __$AppTeamCopyWithImpl<_AppTeam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppTeamToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppTeam&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.teamName, teamName) || other.teamName == teamName)&&(identical(other.createdBy, createdBy) || other.createdBy == createdBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamId,teamName,createdBy);

@override
String toString() {
  return 'AppTeam(teamId: $teamId, teamName: $teamName, createdBy: $createdBy)';
}


}

/// @nodoc
abstract mixin class _$AppTeamCopyWith<$Res> implements $AppTeamCopyWith<$Res> {
  factory _$AppTeamCopyWith(_AppTeam value, $Res Function(_AppTeam) _then) = __$AppTeamCopyWithImpl;
@override @useResult
$Res call({
 String teamId, String teamName, String createdBy
});




}
/// @nodoc
class __$AppTeamCopyWithImpl<$Res>
    implements _$AppTeamCopyWith<$Res> {
  __$AppTeamCopyWithImpl(this._self, this._then);

  final _AppTeam _self;
  final $Res Function(_AppTeam) _then;

/// Create a copy of AppTeam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? teamName = null,Object? createdBy = null,}) {
  return _then(_AppTeam(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,teamName: null == teamName ? _self.teamName : teamName // ignore: cast_nullable_to_non_nullable
as String,createdBy: null == createdBy ? _self.createdBy : createdBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
