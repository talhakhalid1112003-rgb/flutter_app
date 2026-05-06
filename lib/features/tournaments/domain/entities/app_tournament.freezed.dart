// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppTournament {

 String get tournamentId; String get name; String get format;// Test, ODI, T20
 int get overs; List<String> get teamIds; String get status;// active, completed
 DateTime get createdAt;
/// Create a copy of AppTournament
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppTournamentCopyWith<AppTournament> get copyWith => _$AppTournamentCopyWithImpl<AppTournament>(this as AppTournament, _$identity);

  /// Serializes this AppTournament to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppTournament&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.overs, overs) || other.overs == overs)&&const DeepCollectionEquality().equals(other.teamIds, teamIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,name,format,overs,const DeepCollectionEquality().hash(teamIds),status,createdAt);

@override
String toString() {
  return 'AppTournament(tournamentId: $tournamentId, name: $name, format: $format, overs: $overs, teamIds: $teamIds, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AppTournamentCopyWith<$Res>  {
  factory $AppTournamentCopyWith(AppTournament value, $Res Function(AppTournament) _then) = _$AppTournamentCopyWithImpl;
@useResult
$Res call({
 String tournamentId, String name, String format, int overs, List<String> teamIds, String status, DateTime createdAt
});




}
/// @nodoc
class _$AppTournamentCopyWithImpl<$Res>
    implements $AppTournamentCopyWith<$Res> {
  _$AppTournamentCopyWithImpl(this._self, this._then);

  final AppTournament _self;
  final $Res Function(AppTournament) _then;

/// Create a copy of AppTournament
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tournamentId = null,Object? name = null,Object? format = null,Object? overs = null,Object? teamIds = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as int,teamIds: null == teamIds ? _self.teamIds : teamIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppTournament].
extension AppTournamentPatterns on AppTournament {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppTournament value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppTournament() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppTournament value)  $default,){
final _that = this;
switch (_that) {
case _AppTournament():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppTournament value)?  $default,){
final _that = this;
switch (_that) {
case _AppTournament() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tournamentId,  String name,  String format,  int overs,  List<String> teamIds,  String status,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppTournament() when $default != null:
return $default(_that.tournamentId,_that.name,_that.format,_that.overs,_that.teamIds,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tournamentId,  String name,  String format,  int overs,  List<String> teamIds,  String status,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AppTournament():
return $default(_that.tournamentId,_that.name,_that.format,_that.overs,_that.teamIds,_that.status,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tournamentId,  String name,  String format,  int overs,  List<String> teamIds,  String status,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AppTournament() when $default != null:
return $default(_that.tournamentId,_that.name,_that.format,_that.overs,_that.teamIds,_that.status,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppTournament implements AppTournament {
  const _AppTournament({required this.tournamentId, required this.name, required this.format, required this.overs, required final  List<String> teamIds, required this.status, required this.createdAt}): _teamIds = teamIds;
  factory _AppTournament.fromJson(Map<String, dynamic> json) => _$AppTournamentFromJson(json);

@override final  String tournamentId;
@override final  String name;
@override final  String format;
// Test, ODI, T20
@override final  int overs;
 final  List<String> _teamIds;
@override List<String> get teamIds {
  if (_teamIds is EqualUnmodifiableListView) return _teamIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_teamIds);
}

@override final  String status;
// active, completed
@override final  DateTime createdAt;

/// Create a copy of AppTournament
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppTournamentCopyWith<_AppTournament> get copyWith => __$AppTournamentCopyWithImpl<_AppTournament>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppTournamentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppTournament&&(identical(other.tournamentId, tournamentId) || other.tournamentId == tournamentId)&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.overs, overs) || other.overs == overs)&&const DeepCollectionEquality().equals(other._teamIds, _teamIds)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,tournamentId,name,format,overs,const DeepCollectionEquality().hash(_teamIds),status,createdAt);

@override
String toString() {
  return 'AppTournament(tournamentId: $tournamentId, name: $name, format: $format, overs: $overs, teamIds: $teamIds, status: $status, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AppTournamentCopyWith<$Res> implements $AppTournamentCopyWith<$Res> {
  factory _$AppTournamentCopyWith(_AppTournament value, $Res Function(_AppTournament) _then) = __$AppTournamentCopyWithImpl;
@override @useResult
$Res call({
 String tournamentId, String name, String format, int overs, List<String> teamIds, String status, DateTime createdAt
});




}
/// @nodoc
class __$AppTournamentCopyWithImpl<$Res>
    implements _$AppTournamentCopyWith<$Res> {
  __$AppTournamentCopyWithImpl(this._self, this._then);

  final _AppTournament _self;
  final $Res Function(_AppTournament) _then;

/// Create a copy of AppTournament
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tournamentId = null,Object? name = null,Object? format = null,Object? overs = null,Object? teamIds = null,Object? status = null,Object? createdAt = null,}) {
  return _then(_AppTournament(
tournamentId: null == tournamentId ? _self.tournamentId : tournamentId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: null == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String,overs: null == overs ? _self.overs : overs // ignore: cast_nullable_to_non_nullable
as int,teamIds: null == teamIds ? _self._teamIds : teamIds // ignore: cast_nullable_to_non_nullable
as List<String>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
